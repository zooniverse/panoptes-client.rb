require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

module Panoptes
  module Endpoints
    class BaseEndpoint
      attr_reader :auth, :url, :prefix

      # @param auth [Hash<token: String, client_id: String, client_secret: String>] Authentication details
      #   * either nothing,
      #   * a hash with +:token+ (an existing OAuth user token),
      #   * or a hash with +:client_id+ and +:client_secret+
      #     (a keypair for an OAuth Application).
      # @param url [String] API location to use.
      # @param prefix [String] An optional API url prefix
      # @yield Allows an optional block to configure the faraday connection
      # @yieldparam faraday [Faraday::Connection] The faraday connection
      def initialize(auth: {}, url: nil, prefix: nil, &config)
        @auth = auth
        @url = url
        @prefix = prefix
        @config = config
      end

      def connection
        @connection ||= Faraday.new(url) do |faraday|
          auth_request faraday, auth
          configure faraday
        end
      end

      def get(path, query = {})
        request :get, path, query
      end

      def post(path, body = {})
        request :post, path, body
      end

      def put(path, body = {}, etag: nil)
        request :put, path, body, etag_header(etag)
      end

      def patch(path, body = {}, etag: nil)
        request :patch, path, body, etag_header(etag)
      end

      def delete(path, query = {}, etag: nil)
        request :delete, path, query, etag_header(etag)
      end

      def etag_header(etag)
        {}.tap do |headers|
          headers['If-Match'] = etag if etag
        end
      end

      def request(method, path, *args)
        path = "#{prefix}/#{path}" if prefix
        handle_response connection.send(method, path, *args)
      end

      def handle_response(response)
        case response.status
        when 404
          raise ResourceNotFound, status: response.status, body: response.body
        when 400..600
          raise ServerError.new, response.body
        else
          response.body
        end
      end

      protected

      def configure(faraday)
        if @config
          @config.call faraday
        else
          faraday.request :panoptes_api_v1
          faraday.request :json
          faraday.response :json
          faraday.adapter Faraday.default_adapter
        end
      end

      def auth_request(faraday, auth)
        if auth[:token]
          faraday.request :panoptes_access_token,
                          url: url,
                          access_token: auth[:token]
        elsif auth[:client_id] && auth[:client_secret]
          faraday.request :panoptes_client_credentials,
                          url: url,
                          client_id: auth[:client_id],
                          client_secret: auth[:client_secret]
        end
      end
    end
  end
end
