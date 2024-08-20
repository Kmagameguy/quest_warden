class Twitch::OauthClient
  class ApiError < StandardError; end

  attr_accessor :token_expiration_time

  def initialize
    # Initialize with a bogus time to ensure a new request
    # is generated the first time
    @token_expiration_time = Time.current - 1.hour
    @access_token = nil
  end

  def access_token
    return @access_token unless @access_token.nil? || Time.current >= token_expiration_time

    response = Faraday.post("#{oauth_url}") do |f|
      f.headers["Content-Type"] = "application/json"
      f.body = request_body
    end

    if response.success?
      token_data = JSON.parse(response.body, object_class: OpenStruct)
      self.token_expiration_time = Time.current + token_data.expires_in
      @access_token = token_data.access_token
    else
      raise ApiError, "Couldn't retrieve Twitch access token."
    end
  end

  def id
    ENV.fetch("TWITCH_API_CLIENT_ID")
  end

  private

  def request_body
    {
      client_id: id,
      client_secret: secret,
      grant_type: "client_credentials"
    }.to_json
  end

  def secret
    ENV.fetch("TWITCH_API_CLIENT_SECRET")
  end

  def oauth_url
    ENV.fetch("TWITCH_API_OAUTH_URL")
  end
end
