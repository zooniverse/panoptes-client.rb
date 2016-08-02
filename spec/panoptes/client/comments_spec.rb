require 'spec_helper'

describe Panoptes::Client::Comments, :vcr do
  describe '#create_comment' do
    let(:client) { Panoptes::TalkClient.new(url: test_talk_url, auth: {token: test_access_token}, public_key_path: File.expand_path("../../../../data/doorkeeper-jwt-staging.pub", __FILE__)) }

    it 'creates a comment' do
      comment = client.create_comment(
        discussion_id: 165,
        body: "Hello from panoptes-client.rb #{Time.now.to_i}"
      )
      expect(comment['id']).to be
      assert_requested :post, talk_api_url('/comments')
    end
  end
end
