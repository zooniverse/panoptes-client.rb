# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Collections, :vcr do
  let(:client) { user_client }

  describe '#collection' do
    it 'returns a collection with the given id' do
      collection = client.collection(418)
      expect(collection['id']).to eq('418')
      assert_requested :get, api_url('/collections/418')
    end
  end

  describe '#add_subjects_to_collection' do
    it 'adds subjects' do
      client.add_subjects_to_collection(1234, [4567])
      assert_requested :post, api_url('/collections/1234/links/subjects')
    end
  end
end
