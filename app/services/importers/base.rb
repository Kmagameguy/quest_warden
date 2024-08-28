module Importers
  class Base
    class ImportError < StandardError; end

    def initialize
      @igdb = IgdbClient::Api.new
    end

    def import_by_id(id)
      raise_import_error
    end

    protected

    def raise_import_error
      raise ImportError, "Unknown error fetching data."
    end

    attr_reader :igdb
  end
end
