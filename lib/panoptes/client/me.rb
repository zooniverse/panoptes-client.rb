require 'openssl'
require 'jwt'

module Panoptes
  class Client
    module Me
      def me
        panoptes.get("/me")["users"][0]
      end
    end
  end
end
