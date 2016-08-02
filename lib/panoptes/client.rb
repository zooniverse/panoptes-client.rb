require "panoptes/concerns/common_client"
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
    class NotLoggedIn < GenericError; end

    include Panoptes::CommonClient
    include Panoptes::Client::Me
    include Panoptes::Client::Projects
    include Panoptes::Client::Subjects
    include Panoptes::Client::SubjectSets
    include Panoptes::Client::UserGroups
    include Panoptes::Client::Workflows

    def get(path, query = {})
      response = conn.get("/api" + path, query)
      handle_response(response)
    end

    def post(path, body = {})
      response = conn.post("/api" + path, body)
      handle_response(response)
    end

    def put(path, body = {}, etag: nil)
      headers = {}
      headers["If-Match"] = etag if etag

      response = conn.put("/api" + path, body, headers)
      handle_response(response)
    end

    def patch(path, body = {}, etag: nil)
      headers = {}
      headers["If-Match"] = etag if etag

      response = conn.patch("/api" + path, body, headers)
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
