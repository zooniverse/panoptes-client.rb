require 'spec_helper'

describe Panoptes::Client::Discussions, :vcr do
  describe '#discussions' do
    let(:client) { talk_client }
    let(:id) { 35472 }
    let(:type) { "Subject" }

    it 'returns a list of discussions for a given focus id & type' do
      discussions = client.discussions(focus_id: id, focus_type: type)
      expect(discussions.size).to eq(5)
      assert_requested :get, talk_api_url("/discussions?focus_id=#{id}&focus_type=#{type}")
    end
  end
end
