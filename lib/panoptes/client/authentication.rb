require 'deprecate'

module Panoptes
  class Client
    module Authentication
      extend Gem::Deprecate

      def jwt_payload
        raise NotLoggedIn unless @auth[:token]
        payload, = decode_token(@auth[:token])
        payload
      rescue JWT::ExpiredSignature
        raise AuthenticationExpired
      end

      def token_contents
        if !@payload.nil? && expiry_from_payload(@payload) > Time.now.utc
          @payload.fetch('data', {})
        elsif @payload.nil?
          @payload = jwt_payload
          @expires_at = expiry_from_payload(@payload)
          @payload.fetch('data', ())
        else
          raise AuthenticationExpired
        end
      end

      def token_expiry
        @expires_at || expiry_from_payload(jwt_payload)
      end

      def authenticated?
        !!token_contents['id']
      end

      def authenticated_user_login
        raise NotLoggedIn unless authenticated?
        token_contents.fetch('login', nil)
      end

      def authenticated_user_display_name
        raise NotLoggedIn unless authenticated?
        token_contents.fetch('dname', nil)
      end

      def authenticated_user_id
        raise NotLoggedIn unless authenticated?
        token_contents.fetch('id')
      end

      def authenticated_admin?
        raise NotLoggedIn unless authenticated?
        token_contents.fetch('admin', false)
      end

      def current_user
        token_contents
      end
      deprecate :current_user, :token_contents, 2019, 7

      def jwt_signing_public_key
        @jwt_signing_public_key ||= OpenSSL::PKey::RSA.new(File.read(@public_key_path))
      end

      def expiry_from_payload(payload)
        Time.at(payload.fetch('exp',0)).utc
      end

      def decode_token(token)
        payload, = JWT.decode token, jwt_signing_public_key, algorithm: 'RS512'
        payload
      end

      def public_key_for_env(env)
        case env.to_s
        when "staging"
          File.expand_path(File.join("..","..", "..", "..", "data", "doorkeeper-jwt-staging.pub"), __FILE__)
        when "production"
          File.expand_path(File.join("..","..", "..", "..", "data", "doorkeeper-jwt-production.pub"), __FILE__)
        else
          nil
        end
      end
    end
  end
end
