# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Discussions, :vcr do
  describe '#discussions' do
    let(:client) { talk_client }
    let(:id) { 35_472 }
    let(:type) { 'Subject' }

    it 'returns a list of discussions for a given focus id & type' do
      discussions = client.discussions(focus_id: id, focus_type: type)
      expect(discussions.size).to eq(5)
      expected_url = talk_api_url("/discussions?focus_id=#{id}&focus_type=#{type}")
      assert_requested :get, expected_url
    end
  end
end
