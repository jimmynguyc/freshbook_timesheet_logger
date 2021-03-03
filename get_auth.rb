require "launchy"
require "dotenv/load"
require "thin"
require "oauth2"

module Oauth2Helper
  CREDENTIAL_FILE = "oauth_credentials.json".freeze

  def save_token(token)
    File.write(CREDENTIAL_FILE, token.to_hash.to_json)
  end

  def get_oauth_token
    token = begin
        token_hash = JSON.parse File.read(CREDENTIAL_FILE)
        token = OAuth2::AccessToken.from_hash(oauth_client, token_hash)
        token.refresh! if token.expired?
        token
      rescue Errno::ENOENT, JSON::ParserError, RuntimeError
        get_token_from_oauth
      end

    raise "There was a problem fetching the token" unless token
    save_token(token)
    token
  end

  def get_token_from_oauth
    response_html = <<html
<html>
  <head>
    <title>OAuth 2 Flow Complete</title>
  </head>
  <body>
    You have successfully completed the OAuth 2 flow. Please close this browser window and return to your program.
  </body>
</html>
html

    token = nil
    client = oauth_client
    auth_url = client.auth_code.authorize_url(redirect_uri: ENV.fetch("NGROK_URL"))
    server = Thin::Server.new("0.0.0.0", 8080) do
      run lambda { |env|
        req = Rack::Request.new(env)
        token = client.auth_code.get_token(req[:code], redirect_uri: ENV.fetch("NGROK_URL"))
        server.stop()
        [200, { "Content-Type" => "text/html" }, response_html]
      }
    end

    Launchy.open(auth_url)
    server.start()

    token
  end

  def oauth_client
    @oauth_client ||= OAuth2::Client.new(
      ENV.fetch("CLIENT_ID"),
      ENV.fetch("CLIENT_SECRET"),
      :authorize_url => "https://auth.freshbooks.com/service/auth/oauth/authorize",
      :token_url => "https://auth.freshbooks.com/service/auth/oauth/token",
      :site => "https://api.freshbooks.com",
    )
  end
end
