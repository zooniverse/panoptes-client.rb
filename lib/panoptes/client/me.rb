module Panoptes
  class Client
    module Me
      def me
        get("/me")["users"][0]
      end
    end
  end
end
