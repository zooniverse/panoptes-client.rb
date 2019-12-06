# frozen_string_literal: true

require 'panoptes/endpoints/json_api_endpoint'
require 'panoptes/endpoints/json_endpoint'

require 'panoptes/client/authentication'
require 'panoptes/client/cellect'
require 'panoptes/client/classifications'
require 'panoptes/client/collections'
require 'panoptes/client/comments'
require 'panoptes/client/discussions'
require 'panoptes/client/me'
require 'panoptes/client/projects'
require 'panoptes/client/project_preferences'
require 'panoptes/client/subject_sets'
require 'panoptes/client/subjects'
require 'panoptes/client/users'
require 'panoptes/client/user_groups'
require 'panoptes/client/version'
require 'panoptes/client/workflows'

module Panoptes
  class Client
    include Panoptes::Client::Me

    # Panoptes
    include Panoptes::Client::Authentication
    include Panoptes::Client::Classifications
    include Panoptes::Client::Collections
    include Panoptes::Client::Projects
    include Panoptes::Client::ProjectPreferences
    include Panoptes::Client::Subjects
    include Panoptes::Client::SubjectSets
    include Panoptes::Client::Users
    include Panoptes::Client::UserGroups
    include Panoptes::Client::Workflows

    # Talk
    include Panoptes::Client::Comments
    include Panoptes::Client::Discussions

    # Cellect
    include Panoptes::Client::Cellect

    class GenericError < StandardError; end
    class ConnectionFailed < GenericError; end
    class ResourceNotFound < GenericError; end
    class ServerError < GenericError; end
    class NotLoggedIn < GenericError; end
    class AuthenticationExpired < GenericError; end

    attr_reader :env, :auth, :panoptes, :talk, :cellect

    def initialize(env: :production, auth: {}, public_key_path: nil, params: {})
      @env = env
      @auth = auth
      @public_key_path = public_key_path || public_key_for_env(env)
      @panoptes = Panoptes::Endpoints::JsonApiEndpoint.new(
        auth: auth, url: panoptes_url, prefix: '/api', params: params
      )
      @talk = Panoptes::Endpoints::JsonApiEndpoint.new(
        auth: auth, url: talk_url, params: params
      )
      @cellect = Panoptes::Endpoints::JsonEndpoint.new(
        url: panoptes_url, prefix: '/cellect'
      )
    end

    def panoptes_url
      case env
      when :production, 'production'
        'https://panoptes.zooniverse.org'
      else
        'https://panoptes-staging.zooniverse.org'
      end
    end

    def talk_url
      case env
      when :production, 'production'
        'https://talk.zooniverse.org'
      else
        'https://talk-staging.zooniverse.org'
      end
    end
  end
end
