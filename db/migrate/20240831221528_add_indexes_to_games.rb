class AddIndexesToGames < ActiveRecord::Migration[7.2]
  def change
    add_index :games, :name
  end
end
