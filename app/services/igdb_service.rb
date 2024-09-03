require "singleton"

class IgdbService
  include Singleton

  def initialize
    @client = IgdbClient::Api.new
  end

  def get(path, **opts)
    @client.get(path, **opts)
  end

  def game_search(query)
    get(:games, fields: "name,platforms", search: query, limit: 500).sort_by(&:name)
  end
end
