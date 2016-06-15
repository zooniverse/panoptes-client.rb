require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

require "panoptes/client/version"
require "panoptes/client/me"
require "panoptes/client/projects"
require "panoptes/client/subjects"
require "panoptes/client/subject_sets"
require "panoptes/client/user_groups"
require "panoptes/client/workflows"

module Panoptes
  class Client
    class GenericError < StandardError; end
    class ConnectionFailed < GenericError; end
    class ResourceNotFound < GenericError; end
    class ServerError < GenericError; end

    include Panoptes::Client::Me
    include Panoptes::Client::Projects
    include Panoptes::Client::Subjects
    include Panoptes::Client::SubjectSets
    include Panoptes::Client::UserGroups
    include Panoptes::Client::Workflows

    # A client is the main interface to the API.
    #
    # @param auth [Hash] Authentication details
    #   * either nothing,
    #   * a hash with +:token+ (an existing OAuth user token),
    #   * or a hash with +:client_id+ and +:client_secret+ (a keypair for an OAuth Application).
    # @param url [String] Optional override for the API location to use. Defaults to the official production environment.
    def initialize(auth: {}, url: "https://panoptes.zooniverse.org")
      @conn = Faraday.new(url: url) do |faraday|
        case
        when auth[:token]
          faraday.request :panoptes_access_token, url: url, access_token: auth[:token]
        when auth[:client_id] && auth[:client_secret]
          faraday.request :panoptes_client_credentials, url: url, client_id: auth[:client_id], client_secret: auth[:client_secret]
        end

        faraday.request :panoptes_api_v1
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, query = {})
      response = conn.get("/api" + path, query)
      handle_response(response)
    end

    def post(path, body = {})
      response = conn.post("/api" + path, body)
      handle_response(response)
    end

    def put(path, body = {})
      response = conn.put("/api" + path, body)
      handle_response(response)
    end

    def patch(path, body = {})
      response = conn.patch("/api" + path, body)
      handle_response(response)
    end

    def delete(path, query = {}, etag: nil)
      headers = {}
      headers["If-Match"] = etag if etag

      response = conn.delete("/api" + path, query, headers)
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
