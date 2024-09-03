module Importers
  class Genre
    include ::Importers::ImporterErrorable

    def import(genre_data)
      raise ImportError if genre_data.blank?

      ActiveRecord::Base.transaction do
        ::Genre.find_or_create_by(genre_data.slice(:id, :name))
      end
    end
  end
end
