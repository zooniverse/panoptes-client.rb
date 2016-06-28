require "panoptes/concerns/common_client"
require "panoptes/client/discussions"

module Panoptes
  class TalkClient
    include Panoptes::CommonClient
    include Panoptes::Client::Discussions

    # @param auth [Hash] Authentication details
    #   * either nothing,
    #   * a hash with +:token+ (an existing OAuth user token),
    #   * or a hash with +:client_id+ and +:client_secret+ (a keypair for an OAuth Application).
    # A client is the main interface to the talk v2 API.
    # @param url [String] Optional override for the API location to use. Defaults to the official talk api production environment.
    # @param auth_url [String] Optional override for the auth API location to use. Defaults to the official api production environment.
    def initialize(auth: {}, url: PROD_TALK_API_URL, auth_url: PROD_API_URL)
      super(auth: auth, url: url, auth_url: auth_url)
    end

    def get(path, query = {})
      response = conn.get(path, query)
      handle_response(response)
    end
  end
end
