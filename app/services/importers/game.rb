module Importers
  class Game
    include ::Importers::ImporterErrorable

    BATCH_LOOP_DELAY = 1.1 # seconds

    # List of fields (and associated fields) we want to
    # retrieve for storage in the db.
    GAME_FIELDS = %w[
      id
      name
      storyline
      summary
      first_release_date
      platforms.*
      genres.*
      involved_companies.*
      involved_companies.company.*
    ].freeze

    def import_by_ids(game_ids)
      Array(game_ids).each do |game_id|
        game_data = IgdbService.instance.get(:games, id: game_id, fields: GAME_FIELDS.join(",")).to_h

        raise ImportError if game_data.blank?

        ActiveRecord::Base.transaction do
          game = ::Game.find_or_create_by(game_data.slice(:id, :name))
          game.update!(game_data.slice(:storyline, :summary, :first_release_date))

          import(game_data[:platforms].map(&:to_h), :platform) if game_data[:platforms]
          import(game_data[:genres].map(&:to_h), :genre) if game_data[:genres]
          import(game_data[:involved_companies].map(&:to_h), :involved_company) if game_data[:involved_companies]

          game.platforms = ::Platform.where(id: game_data[:platforms]&.pluck(:id))
          game.genres = ::Genre.where(id: game_data[:genres]&.pluck(:id))
          game.involved_companies = ::InvolvedCompany.where(id: game_data[:involved_companies]&.pluck(:id))
        end

        sleep(BATCH_LOOP_DELAY)
      end
    end

    private

    def import(data, klass)
      Array(data).uniq.each do |item|
        puts "Importing #{klass} with id: #{item[:id]}"
        "::Importers::#{klass.to_s.camelcase}".constantize.new.import(item)
      end
    end
  end
end
