module Importers
  class Genre < Base
    def import_by_id(id)
      genre_data = igdb.get(:genres, id: id).to_h

      raise_import_error if genre_data.blank?

      ActiveRecord::Base.transaction do
        ::Genre.find_or_create_by(genre_data.slice(:id, :name))
      end
    end
  end
end
