require_relative 'base_endpoint'

module Panoptes
  module Endpoints
    class TalkEndpoint < BaseEndpoint
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

      def get(path, query = {})
        response = connection.get(path, query)
        handle_response(response)
      end

      def post(path, body = {})
        response = connection.post(path, body)
        handle_response(response)
      end
    end
  end
end
