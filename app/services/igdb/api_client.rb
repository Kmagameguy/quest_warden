# frozen_string_literal: true

class Igdb::ApiClient
  class InvalidEndpoint < StandardError; end

  ENDPOINTS = %i[
    age_ratings
    age_rating_content_descriptions
    alternative_names
    artworks
    characters
    character_mug_shots
    collections
    collection_memberships
    collection_membership_types
    collection_relations
    collection_relation_types
    collection_types
    companies
    company_logos
    company_websites
    covers
    events
    event_logos
    event_networks
    external_games
    franchises
    games
    game_engines
    game_engine_logos
    game_localizations
    game_modes
    game_versions
    game_version_features
    game_version_feature_values
    game_videos
    genres
    involved_companies
    keywords
    languages
    language_supports
    language_support_types
    multiplayer_modes
    network_types
    platforms
    platform_families
    platform_logos
    platform_versions
    platform_version_companies
    platform_version_release_dates
    platform_websites
    player_perspectives
    popularity_primitives
    popularity_types
    regions
    release_dates
    release_date_statuses
    screenshots
    search
    themes
    websites
  ]

  def self.help
    puts "Available endpoints: #{ENDPOINTS.join(", ")}"
  end

  def get(endpoint, params = { fields: '*' })
    raise InvalidEndpoint, "'#{endpoint}' is not a recognized request." unless ENDPOINTS.include?(endpoint.to_sym)

    data = params.map do |field, value|
      if field == :id
        "where id = #{value};"
      else
        "#{field} #{value};"
      end
    end

    data << "fields '*';" if data.none? { |str| str.include?("fields") }

    response = Faraday.post("#{api_base_url}/#{endpoint}") do |req|
      req.headers["Client-ID"] = twitch_oauth_client.id
      req.headers["Authorization"] = "Bearer #{twitch_oauth_client.access_token}"
      req.headers["Content-Type"] = "application/json"
      req.body = data.join("")
    end

    JSON.parse(response.body, object_class: OpenStruct)
  end

  private

  def api_base_url
    ENV.fetch("IGDB_API_BASE_URL")
  end

  def twitch_oauth_client
    @twitch_oauth_client ||= Twitch::OauthClient.new
  end
end
