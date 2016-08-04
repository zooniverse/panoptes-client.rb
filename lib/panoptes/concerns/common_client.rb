
require "panoptes/client/version"

module Panoptes
  module CommonClient
    PROD_API_URL = "https://panoptes.zooniverse.org".freeze
    PROD_TALK_API_URL = "https://talk.zooniverse.org".freeze
    PROD_PUBLIC_KEY_PATH = File.expand_path("../../../../data/doorkeeper-jwt-production.pub", __FILE__)

  end
end
