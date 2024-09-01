class CreateInvolvedCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :involved_companies do |t|
      t.references :game, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.boolean :developer, default: false
      t.boolean :porting, default: false
      t.boolean :publisher, default: false
      t.boolean :supporting, default: false

      t.timestamps
    end
  end
end
