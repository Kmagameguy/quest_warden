module Importers
  class Platform < Base
    def import_by_id(id)
      platform_data = igdb.get(:platforms, id: id).to_h

      raise_import_error if platform_data.blank?

      ActiveRecord::Base.transaction do
        platform = ::Platform.find_or_create_by(platform_data.slice(:id, :name))
        platform.update!(platform_data.slice(:abbreviation, :alternative_name))
      end
    end
  end
end
