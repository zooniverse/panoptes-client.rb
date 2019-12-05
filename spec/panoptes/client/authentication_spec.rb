# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Authentication do
  describe '#token_contents' do
    describe '#jwt_payload' do
      it 'decrypts the token' do
        expect do
          client = user_client
          client.jwt_payload
        end.not_to raise_error
      end

      it 'throws an error for expired tokens' do
        expect do
          client = user_client
          Timecop.freeze(Time.local(2116, 8, 2, 14, 37, 0)) do
            client.jwt_payload
          end
        end.to raise_error(Panoptes::Client::AuthenticationExpired)
      end

      it 'returns the contents' do
        payload = user_client.jwt_payload
        expect(payload).to have_key('data')
        expect(payload).not_to have_key('id')
      end
    end

    describe '#token_contents' do
      let(:client) do
        user_client.tap do |client|
          allow(client).to receive(:decode_token).and_return(
            'data' => { 'id' => 1_323_869 }, 'exp' => (Time.now.utc + 5 * 60).to_i
          )
        end
      end

      it 'returns only the data portion of the JWT' do
        token_contents = client.token_contents
        expect(token_contents).not_to have_key('data')
        expect(token_contents).to have_key('id')
        expect(token_contents['id']).to eq(1_323_869)
      end

      it 'only decodes the token once' do
        client.token_contents
        client.token_contents
        expect(client).to have_received(:decode_token).once
      end

      it 'raises an exception if padded token is expired' do
        expired_jwt_token = fake_access_token(-5*60)
        client = Panoptes::Client.new(
          env: :test,
          auth: { token: expired_jwt_token },
          public_key_path: test_public_key
        )
        expect do
          client.token_contents
        end.to raise_error(Panoptes::Client::AuthenticationExpired)
      end
    end

    describe '#token_expiry' do
      let(:client) do
        user_client
      end

      it 'returns the expiry field' do
        Timecop.freeze(Time.now.utc) do
          now = Time.now.utc
          allow(client).to receive(:jwt_payload).and_return('data' => {}, 'exp' => now.to_i)
          expect(client.token_expiry.to_i).to eq(now.utc.to_i)
        end
      end

      it 'does not cache the contents, but checks the expiry every time' do
        now = Time.now.utc
        allow(client).to receive(:jwt_payload).and_return('data' => {}, 'exp' => now.to_i)
        client.token_expiry
        client.token_expiry
        expect(client).to have_received(:jwt_payload).twice
      end
    end

    describe '#authenticated?' do
      let(:client) do
        user_client
      end

      it 'is true if there is a valid user id' do
        allow(client).to receive(:token_contents).and_return('id' => 1_323_869)
        expect(client.authenticated?).to be true
      end

      it 'is false if there is no valid user id' do
        allow(client).to receive(:token_contents).and_return({})
        expect(client.authenticated?).to be false
      end

      it 'does not cache the result' do
        allow(client).to receive(:token_contents).and_return({})
        client.authenticated?
        client.authenticated?
        expect(client).to have_received(:token_contents).twice
      end
    end

    describe '#authenticated_user_login' do
      let(:client) do
        user_client
      end

      it 'throws an exception if the user is not logged in' do
        allow(client).to receive(:authenticated?).and_return(false)
        expect do
          client.authenticated_user_login
        end.to raise_error(Panoptes::Client::NotLoggedIn)
      end

      it 'returns the user login otherwise' do
        allow(client).to receive(:authenticated?).and_return(true)
        allow(client).to receive(:token_contents).and_return('login' => 'amy')
        expect(client.authenticated_user_login).to eq('amy')
      end

      it 'returns nil unless a login name is provided' do
        allow(client).to receive(:token_contents).and_return('id' => 1)
        expect(client.authenticated_user_login).to be nil
      end

      it 'does not cache the result' do
        allow(client).to receive(:authenticated?).and_return(true)
        allow(client).to receive(:token_contents).and_return('id' => 1, 'login' => 'amy')
        client.authenticated_user_login
        client.authenticated_user_login
        expect(client).to have_received(:token_contents).twice
      end
    end

    describe '#authenticated_user_display_name' do
      let(:client) do
        user_client
      end

      it 'throws an exception if the user is not logged in' do
        allow(client).to receive(:authenticated?).and_return(false)
        expect do
          client.authenticated_user_display_name
        end.to raise_error(Panoptes::Client::NotLoggedIn)
      end

      it 'returns the user display_name otherwise' do
        allow(client).to receive(:authenticated?).and_return(true)
        allow(client).to receive(:token_contents).and_return('dname' => 'amy')
        expect(client.authenticated_user_display_name).to eq('amy')
      end

      it 'returns nil unless a display name is provided' do
        allow(client).to receive(:token_contents).and_return('id' => 1)
        expect(client.authenticated_user_display_name).to be nil
      end

      it 'does not cache the result' do
        allow(client).to receive(:authenticated?).and_return(true)
        allow(client).to receive(:token_contents).and_return('id' => 1, 'dname' => 'amy')
        client.authenticated_user_display_name
        client.authenticated_user_display_name
        expect(client).to have_received(:token_contents).twice
      end
    end

    describe '#authenticated_admin?' do
      let(:client) do
        user_client
      end

      it 'recognizes admins' do
        allow(client).to receive(:token_contents).and_return('id' => 1, 'admin' => true)
        expect(client.authenticated_admin?).to be true
      end

      it 'rejects non-admins' do
        allow(client).to receive(:token_contents).and_return('id' => 1, 'admin' => false)
        expect(client.authenticated_admin?).to be false
        allow(client).to receive(:token_contents).and_return('id' => 1)
        expect(client.authenticated_admin?).to be false
      end

      it 'does not cache the value' do
        allow(client).to receive(:authenticated?).and_return(true)
        allow(client).to receive(:token_contents).and_return('id' => 1, 'admin' => true)
        client.authenticated_admin?
        client.authenticated_admin?
        expect(client).to have_received(:token_contents).twice
      end
    end

    describe 'current_user' do
      let(:client) do
        user_client
      end

      it 'is the same as token contents' do
        payload_data = { 'id' => 1, 'admin' => true }
        allow(client).to receive(:token_contents).and_return(payload_data)
        expect(client.current_user).to eq(payload_data)
        expect(client).to have_received(:token_contents).once
      end
    end

    it 'raises when not logged in' do
      client = unauthenticated_client
      expect { client.token_contents }.to raise_error(Panoptes::Client::NotLoggedIn)
    end
  end
end
