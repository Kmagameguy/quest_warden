module Importers
  class Game
    include ::Importers::ImporterErrorable

    BATCH_LOOP_DELAY = 1.1 # seconds

    def import_by_id(id)
      game_data = IgdbService.instance.get(:games, id: id).to_h

      raise ImportError if game_data.blank?

      ActiveRecord::Base.transaction do
        game = ::Game.find_or_create_by(game_data.slice(:id, :name))
        game.update!(game_data.slice(:storyline, :summary, :first_release_date))

        import_platforms(game_data[:platforms])
        import_genres(game_data[:genres])
        sleep(BATCH_LOOP_DELAY)
        import_involved_companies(game_data[:involved_companies])

        game.platforms = ::Platform.where(id: game_data[:platforms])
        game.genres = ::Genre.where(id: game_data[:genres])
        game.involved_companies = ::InvolvedCompany.where(id: game_data[:involved_companies])
      end
    end

    private

    def import_platforms(platform_ids)
      Array(platform_ids).uniq.each_slice(4) do |batch|
        batch.each do |platform_id|
          puts "Importing platform with id: #{platform_id}"
          ::Importers::Platform.new.import_by_id(platform_id)
        end
        sleep(BATCH_LOOP_DELAY)
      end
    end

    def import_genres(genre_ids)
      Array(genre_ids).uniq.each_slice(4) do |batch|
        batch.each do |genre_id|
          puts "Importing genre with id: #{genre_id}"
          ::Importers::Genre.new.import_by_id(genre_id)
        end
        sleep(BATCH_LOOP_DELAY)
      end
    end

    # Because of the way the game <-> company relationship is
    # modeled, this action also creates company records
    def import_involved_companies(involved_company_ids)
      Array(involved_company_ids).uniq.each_slice(3) do |batch|
        batch.each do |involved_company_id|
          puts "Importing Involved Company with id: #{involved_company_id}"
          ::Importers::InvolvedCompany.new.import_by_id(involved_company_id)
        end
        sleep(BATCH_LOOP_DELAY)
      end
    end
  end
end
