class AddIndexesToInvolvedCompanies < ActiveRecord::Migration[7.2]
  def change
    add_index :involved_companies, :developer
    add_index :involved_companies, :publisher
    add_index :involved_companies, :porting
    add_index :involved_companies, :supporting
  end
end
