class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :name
      t.text :storyline
      t.text :summary

      t.timestamps
    end
  end
end
