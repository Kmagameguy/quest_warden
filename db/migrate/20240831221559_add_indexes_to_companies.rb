class AddIndexesToCompanies < ActiveRecord::Migration[7.2]
  def change
    add_index :companies, :name
  end
end
