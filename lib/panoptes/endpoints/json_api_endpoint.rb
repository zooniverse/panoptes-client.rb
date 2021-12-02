# frozen_string_literal: true

require_relative 'base_endpoint'

module Panoptes
  module Endpoints
    class JsonApiEndpoint < BaseEndpoint
      # Get a path and perform automatic depagination
      def paginate(path, query, resource: nil)
        resource = path.split('/').last if resource.nil?
        data = last_response = get(path, query)

        # ensure we yield the first page of data
        yield data, last_response if block_given?

        # while we have more result set pages
        while (next_path = last_response['meta'][resource]['next_href'])
          # fetch next page of data
          last_response = get(next_path, query)
          if block_given?
            # if we pass a block then yield the first page and current page responses
            yield data, last_response
          else
            # add to the data representation of all result set pages
            data[resource].concat(last_response[resource]) if data[resource].is_a?(Array)
            data['meta'][resource].merge!(last_response['meta'][resource])
            data['links'].merge!(last_response['links'])
          end
        end

        # return the data results for when we don't use a block to process response pages
        data
      end
    end
  end
end
