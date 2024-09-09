class CreateRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :ratings do |t|
      t.integer :user_id,     null: false
      t.decimal :value,       precision: 3, scale: 1, null: false
      t.integer :rateable_id, null: false
      t.string  :rateable_type, null: false

      t.timestamps
    end
    add_index :ratings, [ :user_id, :rateable_id, :rateable_type ], unique: true
  end
end
