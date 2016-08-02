require 'spec_helper'

describe Panoptes::Client::Me do
  describe '#me' do
    describe 'unauthenticated', :vcr do
      let(:client) { unauthenticated_client }
      it 'returns information about the anonymous user'
    end

    describe 'with application auth', :vcr do
      let(:client) { application_client }
      it 'returns information about the owner of the application'
    end

    describe 'with access token auth', :vcr do
      let(:client) { user_client }

      it 'returns information about the user' do
        me = client.me
        expect(me).to include({"id" => "1323869"})
        assert_requested :get, api_url('/me')
      end
    end
  end

  describe '#jwt' do
    it 'returns JWT payload' do
      Timecop.freeze(Time.local(2016, 8, 2, 14, 37, 0)) do
        client = user_client
        jwt = client.jwt
        expect(jwt).to include({"id" => 1323869})
      end
    end

    it 'raises when not logged in' do
      client = unauthenticated_client
      expect { client.jwt }.to raise_error(Panoptes::Client::NotLoggedIn)
    end
  end
end
