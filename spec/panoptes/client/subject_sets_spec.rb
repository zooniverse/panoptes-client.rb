require 'spec_helper'

describe Panoptes::Client::SubjectSets, :vcr do
  describe '#subject_set' do
    let(:client) { unauthenticated_client }

    it 'returns a subject_set given the id' do
      subject_set = client.subject_set(2376)
      expect(subject_set['id']).to eq('2376')
      assert_requested :get, api_url('/subject_sets/2376')
    end
  end

  describe '#create_subject_set' do
    let(:client) { user_client }

    it 'creates a subject_set' do
      subject_set = client.create_subject_set(
        display_name: 'panoptes-client.rb test',
        links: {project: 813}
      )
      expect(subject_set['id']).to be
      assert_requested :post, api_url('/subject_sets')
    end
  end
end
