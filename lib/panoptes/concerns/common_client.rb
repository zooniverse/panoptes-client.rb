require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

require "panoptes/client/version"

module Panoptes
  module CommonClient
    PROD_API_URL = "https://panoptes.zooniverse.org".freeze
    PROD_TALK_API_URL = "https://talk.zooniverse.org".freeze
    PROD_PUBLIC_KEY_PATH = File.expand_path("../../../../data/doorkeeper-jwt-production.pub", __FILE__)

    # A client is the main interface to the API.
    #
    # @param auth [Hash] Authentication details
    #   * either nothing,
    #   * a hash with +:token+ (an existing OAuth user token),
    #   * or a hash with +:client_id+ and +:client_secret+ (a keypair for an OAuth Application).
    # @param url [String] API location to use.
    # @param auth_url [String] Auth API location to use.
    def initialize(auth: {}, url: PROD_API_URL, auth_url: PROD_API_URL, public_key_path: PROD_PUBLIC_KEY_PATH)
      @auth = auth
      @public_key_path = public_key_path
      @conn = Faraday.new(url: url) do |faraday|
        case
        when auth[:token]
          faraday.request :panoptes_access_token,
            url: auth_url,
            access_token: auth[:token]
        when auth[:client_id] && auth[:client_secret]
          faraday.request :panoptes_client_credentials,
            url: auth_url,
            client_id: auth[:client_id],
            client_secret: auth[:client_secret]
        end

        faraday.request :panoptes_api_v1
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def jwt
      raise Panoptes::Client::NotLoggedIn unless @auth[:token]

      payload, header = JWT.decode @auth[:token], jwt_signing_public_key, {algorithm: 'RS512'}
      payload.fetch("data")
    end

    def jwt_signing_public_key
      @jwt_signing_public_key ||= OpenSSL::PKey::RSA.new(File.read(@public_key_path))
    end

    # Get a path and perform automatic depagination
    def paginate(path, query, resource: nil)
      resource = path.split("/").last if resource.nil?
      data = last_response = get(path, query)

      while next_path = last_response["meta"][resource]["next_href"]
        last_response = get(next_path, query)
        if block_given?
          yield data, last_response
        else
          data[resource].concat(last_response[resource]) if data[resource].is_a?(Array)
          data["meta"][resource].merge!(last_response["meta"][resource])
          data["links"].merge!(last_response["links"])
        end
      end

      data
    end

    private

    def conn
      @conn
    end

    def handle_response(response)
      case response.status
      when 404
        raise ResourceNotFound, status: response.status, body: response.body
      when 400..600
        raise ServerError.new(response.body)
      else
        response.body
      end
    end
  end
end
