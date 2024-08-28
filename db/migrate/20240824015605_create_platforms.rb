class CreatePlatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :platforms do |t|
      t.string  :abbreviation
      t.string  :alternative_name
      t.string  :name

      t.timestamps
    end
  end
end
