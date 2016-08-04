require 'spec_helper'

describe Panoptes::Client do
  describe '#current_user' do
    it 'returns current_user payload' do
      Timecop.freeze(Time.local(2016, 8, 2, 14, 37, 0)) do
        client = user_client
        current_user = client.current_user
        expect(current_user).to include({"id" => 1323869})
      end
    end

    it 'raises when not logged in' do
      client = unauthenticated_client
      expect { client.current_user }.to raise_error(Panoptes::Client::NotLoggedIn)
    end
  end
end
