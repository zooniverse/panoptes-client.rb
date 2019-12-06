# frozen_string_literal: true

module Panoptes
  class Client
    module Comments
      # Post a comment to a talk discussion
      #
      # @param discussion_id [Integer] filter by focussable id
      # @param focus_type [String] filter by focussable type
      # @return list of discussions
      def create_comment(discussion_id:, body:)
        user_id = token_contents['id']
        response = talk.post('/comments', comments: { discussion_id: discussion_id, body: body, user_id: user_id })
        response.fetch('comments')[0]
      end
    end
  end
end
