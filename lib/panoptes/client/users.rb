module Panoptes
  class Client
    module Users
      def user(user_id)
        response = panoptes.get("users/#{user_id}")
        response.fetch("users").find{ |i| i.fetch("id").to_s == user_id.to_s }
      end
    end
  end
end
