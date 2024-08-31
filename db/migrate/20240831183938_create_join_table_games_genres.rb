class CreateJoinTableGamesGenres < ActiveRecord::Migration[7.2]
  def change
    create_join_table :games, :genres do |t|
      t.index :game_id
      t.index :genre_id
    end
  end
end
