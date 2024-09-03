module Importers
  class InvolvedCompany
    include ::Importers::ImporterErrorable

    def import(involved_company_data)
      raise ImportError if involved_company_data.blank?

      company_data = IgdbService.instance.get(:companies, id: involved_company_data[:company]).to_h

      raise ImportError if company_data.blank?

      ActiveRecord::Base.transaction do
        company = ::Company.find_or_create_by(company_data.slice(:id, :name))
        company.update!(company_data.slice(:country, :parent_id))

        involved_company = ::InvolvedCompany.find_or_initialize_by(id: involved_company_data[:id], game_id: involved_company_data[:game], company_id: involved_company_data[:company])

        involved_company.assign_attributes(
          developer: involved_company_data[:developer],
          porting: involved_company_data[:porting],
          publisher: involved_company_data[:publisher],
          supporting: involved_company_data[:supporting]
        )

        involved_company.save!

        company.send(:involved_companies) << involved_company if company.send(:involved_companies).exclude?(company)

        return involved_company
      end
    end
  end
end
