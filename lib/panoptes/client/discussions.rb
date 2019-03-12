# frozen_string_literal: true

module Panoptes
  class Client
    module Discussions
      # Get list of talk discussions
      #
      # @param focus_id [Integer] filter by focussable id
      # @param focus_type [String] filter by focussable type
      # @return list of discussions
      def discussions(focus_id:, focus_type:)
        query = {}
        query[:focus_id] = focus_id
        query[:focus_type] = focus_type

        response = talk.get('/discussions', query)
        response.fetch('discussions')
      end
    end
  end
end
