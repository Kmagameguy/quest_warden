module Importers
  module ImporterErrorable
    class ImportError < StandardError
      def message
        "Unknown error fetching data."
      end
    end
  end
end
