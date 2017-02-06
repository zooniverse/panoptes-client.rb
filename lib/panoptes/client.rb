require 'panoptes/endpoints/json_api_endpoint'
require 'panoptes/endpoints/json_endpoint'

require 'panoptes/client/cellect'
require 'panoptes/client/collections'
require 'panoptes/client/comments'
require 'panoptes/client/discussions'
require 'panoptes/client/me'
require 'panoptes/client/projects'
require 'panoptes/client/subject_sets'
require 'panoptes/client/subjects'
require 'panoptes/client/user_groups'
require 'panoptes/client/version'
require 'panoptes/client/workflows'

module Panoptes
  class Client
    include Panoptes::Client::Me
    include Panoptes::Client::Projects
    include Panoptes::Client::Subjects
    include Panoptes::Client::SubjectSets
    include Panoptes::Client::UserGroups
    include Panoptes::Client::Workflows

    include Panoptes::Client::Discussions
    include Panoptes::Client::Comments

    include Panoptes::Client::Collections

    include Panoptes::Client::Cellect

    class GenericError < StandardError; end
    class ConnectionFailed < GenericError; end
    class ResourceNotFound < GenericError; end
    class ServerError < GenericError; end
    class NotLoggedIn < GenericError; end

    attr_reader :env, :auth, :panoptes, :talk, :cellect

    def initialize(env: :production, auth: {}, public_key_path: nil)
      @env = env
      @auth = auth
      @public_key_path = public_key_path
      @panoptes = Panoptes::Endpoints::JsonApiEndpoint.new(
        auth: auth, url: panoptes_url, prefix: '/api'
      )
      @talk = Panoptes::Endpoints::JsonApiEndpoint.new(
        auth: auth, url: talk_url
      )
      @cellect = Panoptes::Endpoints::JsonEndpoint.new(
        url: panoptes_url, prefix: '/cellect'
      )
    end

    def current_user
      raise NotLoggedIn unless @auth[:token]

      payload, = JWT.decode @auth[:token], jwt_signing_public_key, algorithm: 'RS512'
      payload.fetch('data')
    end

    def jwt_signing_public_key
      @jwt_signing_public_key ||= OpenSSL::PKey::RSA.new(File.read(@public_key_path))
    end

    def panoptes_url
      case env
      when :production, 'production'.freeze
        'https://panoptes.zooniverse.org'.freeze
      else
        'https://panoptes-staging.zooniverse.org'.freeze
      end
    end

    def talk_url
      case env
      when :production, 'production'.freeze
        'https://talk.zooniverse.org'.freeze
      else
        'https://talk-staging.zooniverse.org'.freeze
      end
    end
  end
end
