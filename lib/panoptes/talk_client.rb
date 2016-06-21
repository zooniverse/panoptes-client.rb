require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

require "panoptes/client/version"
require "panoptes/client/discussions"

module Panoptes
  class TalkClient
    include Panoptes::Client::Discussions

    # A client is the main interface to the talk v2 API.
    # @param url [String] Optional override for the API location to use. Defaults to the official production environment.
    def initialize(url: "https://talk.zooniverse.org")
      @conn = Faraday.new(url: url) do |faraday|
        faraday.request :panoptes_api_v1
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, query = {})
      response = conn.get(path, query)
      handle_response(response)
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
