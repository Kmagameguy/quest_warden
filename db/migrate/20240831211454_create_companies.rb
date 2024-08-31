class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :country
      t.string :name, null: false
      t.references :parent, foreign_key: { to_table: :companies }

      t.timestamps
    end
  end
end
