module Importers
  class Base
    class ImportError < StandardError; end

    def initialize(igdb_client:)
      @igdb = igdb_client
    end

    def import_by_id(id)
      raise_import_error
    end

    def raise_import_error
      raise ImportError, "Unknown error fetching data."
    end

    attr_reader :igdb
  end
end
