# frozen_string_literal: true

require 'deprecate'

module Panoptes
  class Client
    module Authentication
      extend Gem::Deprecate

      attr_reader :payload

      def jwt_payload
        raise NotLoggedIn unless @auth[:token]
        @payload = decode_token(@auth[:token])
      rescue JWT::ExpiredSignature
        raise AuthenticationExpired
      end

      def token_contents
        if payload_exists? && !payload_expired?
          # use the cached version of the payload while not expired
          payload['data']
        else
          # decode the payload from the JWT token
          jwt_payload['data']
        end
      end

      def token_expiry
        # always decode and fetch the expiry time from the JWT token
        Time.at(jwt_payload.fetch('exp',0)).utc
      end

      def authenticated?
        !!token_contents['id']
      end

      def authenticated_user_login
        ensure_authenticated
        token_contents.fetch('login', nil)
      end

      def authenticated_user_display_name
        ensure_authenticated
        token_contents.fetch('dname', nil)
      end

      def authenticated_user_id
        ensure_authenticated
        token_contents.fetch('id')
      end

      def authenticated_admin?
        ensure_authenticated
        token_contents.fetch('admin', false)
      end

      private

      def ensure_authenticated
        raise NotLoggedIn unless authenticated?
      end

      def payload_exists?
        !!@payload
      end

      def payload_expiry_time
        @payload_expiry_time ||= Time.at(payload.fetch('exp',0)).utc
      end

      def payload_expired?
        payload_expiry_time < Time.now.utc
      end

      def jwt_signing_public_key
        @jwt_signing_public_key ||= OpenSSL::PKey::RSA.new(File.read(@public_key_path))
      end

      def decode_token(token)
        payload, = JWT.decode token, jwt_signing_public_key, algorithm: 'RS512'
        payload
      end

      def public_key_for_env(env)
        case env.to_s
        when 'staging'
          key_file_path('doorkeeper-jwt-staging.pub')
        when 'production'
          key_file_path('doorkeeper-jwt-production.pub')
        end
      end

      def key_file_path(file_name)
        File.expand_path(
          File.join('..', '..', '..', '..', 'data', file_name),
          __FILE__
        )
      end
    end
  end
end
