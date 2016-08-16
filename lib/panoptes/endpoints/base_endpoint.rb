require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

module Panoptes
  module Endpoints

    class BaseEndpoint
      attr_reader :auth
      attr_reader :url

      # @param auth [Hash] Authentication details
      #   * either nothing,
      #   * a hash with +:token+ (an existing OAuth user token),
      #   * or a hash with +:client_id+ and +:client_secret+ (a keypair for an OAuth Application).
      # @param url [String] API location to use.
      # @param auth_url [String] Auth API location to use.
      def initialize(auth: {}, url: nil)
        @auth = auth
        @url = url
      end

      def connection
        @connection ||= Faraday.new(url: url) do |faraday|
          case
          when auth[:token]
            faraday.request :panoptes_access_token,
              url: url,
              access_token: auth[:token]
          when auth[:client_id] && auth[:client_secret]
            faraday.request :panoptes_client_credentials,
              url: url,
              client_id: auth[:client_id],
              client_secret: auth[:client_secret]
          end

          faraday.request :panoptes_api_v1
          faraday.request :json
          faraday.response :json
          faraday.adapter Faraday.default_adapter
        end
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
end
