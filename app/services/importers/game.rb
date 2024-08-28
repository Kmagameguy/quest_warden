module Importers
  class Game < Base
    def import_by_id(id)
      game_data = igdb.get(:games, id: id).first.to_h

      raise_import_error if game_data.blank?

      ActiveRecord::Base.transaction do
        game = ::Game.find_or_create_by(game_data.slice(:id, :name))
        game.update!(game_data.slice(:storyline, :summary))
        import_platforms(game_data[:platforms])
        game.platforms << ::Platform.where(id: game_data[:platforms])
      end
    end

    def import_platforms(platform_ids)
      Array(platform_ids).each_slice(4) do |batch|
        batch.each do |platform_id|
          puts "Importing platform with id: #{platform_id}"
          ::Importers::Platform.new.import_by_id(platform_id)
        end
        sleep(2.0)
      end
    end
  end
end
