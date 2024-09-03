module Importers
  class Platform
    include ::Importers::ImporterErrorable

    def import(platform_data)
      raise ImportError if platform_data.blank?

      ActiveRecord::Base.transaction do
        platform = ::Platform.find_or_create_by(platform_data.slice(:id, :name))
        platform.update!(platform_data.slice(:abbreviation, :alternative_name))
      end
    end
  end
end
