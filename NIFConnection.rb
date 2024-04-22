require 'httparty'
require 'base64'
require 'dotenv'
Dotenv.load

class NIFConnection
  include HTTParty

  base_uri 'https://id.nif.no'

  def initialize(client_id: ENV["NIF_CLIENT_ID"], client_secret: ENV["NIF_CLIENT_SECRET"], scope:)
    @client_id = client_id
    @client_secret = client_secret
    @scope = scope
  end

  def get_access_token
    auth_header = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
    headers = {
      'Authorization' => "Basic #{auth_header}",
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    body = {
      'grant_type' => 'client_credentials',
      'scope' => @scope
    }

    response = self.class.post('/connect/token', headers: headers, body: body)
    response.parsed_response['access_token']
  end

  def request(endpoint, method: :get, headers: {}, body: {})
    access_token = get_access_token
    headers['Authorization'] = "Bearer #{access_token}"

    case method
    when :get
      self.class.get(endpoint, headers: headers)
    when :post
      self.class.post(endpoint, headers: headers, body: body)
    # Add more HTTP methods as needed
    else
      raise "Unsupported HTTP method: #{method}"
    end
  end
end
