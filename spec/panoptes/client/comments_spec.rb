require 'spec_helper'

describe Panoptes::Client::Comments, :vcr do
  describe '#create_comment' do
    let(:client) { user_client }

    it 'creates a comment' do
      Timecop.freeze(Time.at(1470146174)) do
        comment = client.create_comment(
          discussion_id: 165,
          body: "Hello from panoptes-client.rb #{Time.now.to_i}"
        )
        expect(comment['id']).to be
        assert_requested :post, talk_api_url('/comments')
      end
    end
  end
end
