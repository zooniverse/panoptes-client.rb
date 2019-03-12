# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Collections, :vcr do
  describe '#add_subjects_to_collection' do
    let(:client) { user_client }

    it 'adds subjects' do
      client.add_subjects_to_collection(1234, [4567])
      assert_requested :post, api_url('/collections/1234/links/subjects')
    end
  end
end
