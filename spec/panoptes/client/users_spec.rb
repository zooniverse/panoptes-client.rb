require 'spec_helper'

describe Panoptes::Client::Users, :vcr do
  describe '#users' do
      let(:client) { user_client }

      it 'returns the user object' do
        usr = client.user(1_325_801)
        expect(usr).to include({"id" => "1325801"})
        assert_requested :get, api_url("/users/1325801")
      end
  end
end
