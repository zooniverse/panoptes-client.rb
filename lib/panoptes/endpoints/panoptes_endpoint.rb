require_relative 'base_endpoint'

module Panoptes
  module Endpoints
    class PanoptesEndpoint < BaseEndpoint
      DEFAULT_URL = "https://panoptes.zooniverse.org".freeze

      def get(path, query = {})
        response = connection.get("/api" + path, query)
        handle_response(response)
      end

      def post(path, body = {})
        response = connection.post("/api" + path, body)
        handle_response(response)
      end

      def put(path, body = {}, etag: nil)
        headers = {}
        headers["If-Match"] = etag if etag

        response = connection.put("/api" + path, body, headers)
        handle_response(response)
      end

      def patch(path, body = {}, etag: nil)
        headers = {}
        headers["If-Match"] = etag if etag

        response = connection.patch("/api" + path, body, headers)
        handle_response(response)
      end

      def delete(path, query = {}, etag: nil)
        headers = {}
        headers["If-Match"] = etag if etag

        response = connection.delete("/api" + path, query, headers)
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
    end
  end
end
