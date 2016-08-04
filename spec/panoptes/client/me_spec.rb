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
end
