namespace :data do
  desc "Import a list of games from IGDB"
  task import_games: :environment do
    # IGDB queries are rate limited to 4 requests per second.
    # Batch and sleep between batches to try and respect those limits.
    [ 114283, 7194, 119171, 119133, 45181, 2985, 119388, 26472, 204350, 1942, 6036, 1802, 19560, 1009, 1103, 9927, 7346, 1105, 1026, 112875 ].each_slice(4) do |batch|
      batch.each do |game_id|
        puts "Importing game with id: #{game_id}"
        ::Importers::Game.new.import_by_id(game_id)
      end
      sleep(1.0)
    end
  end
end
