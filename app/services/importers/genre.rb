module Importers
  class Genre
    include ::Importers::ImporterErrorable

    def import_by_id(id)
      genre_data = IgdbService.instance.get(:genres, id: id).to_h

      raise ImportError if genre_data.blank?

      ActiveRecord::Base.transaction do
        ::Genre.find_or_create_by(genre_data.slice(:id, :name))
      end
    end
  end
end
