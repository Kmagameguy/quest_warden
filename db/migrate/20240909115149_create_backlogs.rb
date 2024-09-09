class CreateBacklogs < ActiveRecord::Migration[7.2]
  def change
    create_table :backlogs do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
