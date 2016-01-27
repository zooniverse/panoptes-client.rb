require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

require "panoptes/client/version"
require "panoptes/client/me"
require "panoptes/client/projects"
require "panoptes/client/subjects"
require "panoptes/client/user_groups"

module Panoptes
  class Client
    include Panoptes::Client::Me
    include Panoptes::Client::Projects
    include Panoptes::Client::Subjects
    include Panoptes::Client::UserGroups

    def initialize(auth: {}, url: "https://panoptes.zooniverse.org")
      @conn = Faraday.new(url: url) do |faraday|
        case
        when auth[:token]
          faraday.request :panoptes_access_token, url: url, access_token: token
        when auth[:client_id] && auth[:client_secret]
          faraday.request :panoptes_client_credentials, url: url, client_id: client_id, client_secret: client_secret
        end

        faraday.request :panoptes_api_v1
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, query = {})
      conn.get("/api" + path, query).body
    end

    def post(path, body = {})
      conn.post("/api" + path, body).body
    end

    # Get a path and perform automatic depagination
    def paginate(path, resource: nil)
      resource = path.split("/").last if resource.nil?
      data = last_response = get(path)

      while next_path = last_response["meta"][resource]["next_href"]
        last_response = get(next_path)
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
  end
end
