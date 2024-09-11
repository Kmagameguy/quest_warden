class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.integer :user_id, null: false
      t.integer :favoritable_id, null: false
      t.string  :favoritable_type, null: false

      t.timestamps
    end
    add_index :favorites, [ :user_id, :favoritable_id, :favoritable_type ], unique: true
  end
end
