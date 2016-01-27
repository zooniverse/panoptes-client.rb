module Panoptes
  class Client
    module UserGroups
      def create_user_group(name)
        post("/user_groups", user_groups: {
          name: name
        })["user_groups"][0]
      end
    end
  end
end
