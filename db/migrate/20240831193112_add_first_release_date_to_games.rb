class AddFirstReleaseDateToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :first_release_date, :bigint
  end
end
