module Panoptes
  class Client
    module UserGroups
      # Creates a new user group and puts the current user in it as the initial member.
      #
      # @see http://docs.panoptes.apiary.io/#reference/user-group/usergroup-collection/create-a-user-group
      # @param name [String] The name of the user group. Must be unique for the entirity of Zooniverse.
      # @return [Hash] The created user group.
      def create_user_group(name)
        panoptes.post("/user_groups", user_groups: {
          name: name
        })["user_groups"][0]
      end

      def user_groups
        panoptes.get("/user_groups")["user_groups"]
      end

      def join_user_group(user_group_id, user_id, join_token:)
        panoptes.post("/memberships", memberships: {
          join_token: join_token,
          links: {user: user_id, user_group: user_group_id}
        })["memberships"][0]
      end

      def remove_user_from_user_group(user_group_id, user_id)
        panoptes.delete("/user_groups/#{user_group_id}/links/users/#{user_id}")
      end

      def delete_user_group(user_group_id)
        response = panoptes.connection.get("/api/user_groups/#{user_group_id}")
        etag = response.headers["ETag"]

        panoptes.delete("/user_groups/#{user_group_id}", {}, etag: etag)
      end
    end
  end
end
