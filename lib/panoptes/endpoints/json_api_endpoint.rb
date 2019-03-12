# frozen_string_literal: true

require_relative 'base_endpoint'

module Panoptes
  module Endpoints
    class JsonApiEndpoint < BaseEndpoint
      # Get a path and perform automatic depagination
      def paginate(path, query, resource: nil)
        resource = path.split('/').last if resource.nil?
        data = last_response = get(path, query)

        while next_path = last_response['meta'][resource]['next_href']
          last_response = get(next_path, query)
          if block_given?
            yield data, last_response
          else
            data[resource].concat(last_response[resource]) if data[resource].is_a?(Array)
            data['meta'][resource].merge!(last_response['meta'][resource])
            data['links'].merge!(last_response['links'])
          end
        end

        data
      end
    end
  end
end
