class IgdbSearchService
  def initialize
    @client = IgdbClient::Api.new
  end

  def search(query)
    client.get(:games, fields: "name,platforms", search: query, limit: 35).sort_by(&:name)
  end

  attr_reader :client
end
