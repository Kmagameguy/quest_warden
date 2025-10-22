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
    # Apply some filtering to try and cut out some of the noise that exists in the IGDB...
    get(:games, fields: "name,game_type.type,game_status.status,platforms", search: query, filter: "where rating >= 1", limit: 500)
      .reject { |game| game&.game_type&.type&.in?([ "DLC", "Bundle", "Mod", "Port", "Fork", "Pack / Addon", "Update" ]) }
      .reject { |game| game&.game_status&.status&.in?([ "Cancelled", "Rumored" ]) }
      .sort_by(&:name)
  end
end
