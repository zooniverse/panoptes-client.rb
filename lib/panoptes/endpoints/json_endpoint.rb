require_relative 'base_endpoint'

module Panoptes
  module Endpoints
    class JsonEndpoint < BaseEndpoint
      # Automatically configured connection to use JSON requests/responses
      # @see Panoptes::Endpoints::BaseEndpoint#initialize
      def initialize(auth: {}, url: nil, prefix: nil, &config)
        super auth: auth, url: url, prefix: prefix do |faraday|
          config.call(faraday) if config
          faraday.request :json
          faraday.response :json
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
