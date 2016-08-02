require 'spec_helper'

describe Panoptes::Client do
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
