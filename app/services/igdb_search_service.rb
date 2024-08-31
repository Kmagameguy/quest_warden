class IgdbSearchService
  def initialize
    @client = IgdbClient::Api.new
  end

  def search(query)
    @search_results = client.get(:games, fields: "name,platforms", search: query, limit: 35)
    rebuild_games
  end

  private

  # Sometimes we'll get multiple results for the same game.
  # I'm not sure why the IGDB does this ... possibly for special versions
  # or something.  For now it's kind of annoying and makes the search results
  # kind of crappy.  Let's merge them all into a single item; we can undo this
  # later if there's a need for it.
  def rebuild_games
    grouped_results.map do |name, properties|
      combined_platforms = properties.flat_map(&:platforms).uniq

      OpenStruct.new(
        id: properties.first.id,
        name: name,
        platforms: combined_platforms
      )
    end.sort_by(&:name)
  end

  def grouped_results
    search_results.group_by(&:name)
  end

  attr_reader :client, :search_results
end
