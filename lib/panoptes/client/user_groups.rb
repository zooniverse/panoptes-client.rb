module Panoptes
  class Client
    module UserGroups
      # Creates a new user group and puts the current user in it as the initial member.
      #
      # @see http://docs.panoptes.apiary.io/#reference/user-group/usergroup-collection/create-a-user-group
      # @param name [String] The name of the user group. Must be unique for the entirity of Zooniverse.
      # @return [Hash] The created user group.
      def create_user_group(name)
        post("/user_groups", user_groups: {
          name: name
        })["user_groups"][0]
      end
    end
  end
end
