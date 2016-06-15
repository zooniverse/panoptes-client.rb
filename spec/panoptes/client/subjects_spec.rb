require 'spec_helper'

describe Panoptes::Client::Subjects, :vcr do
  describe '#subjects' do
    let(:client) { unauthenticated_client }

    it 'returns a list of subjects for a given subject_set_id' do
      subjects = client.subjects(subject_set_id: 2376)
      expect(subjects.size).to eq(8)
      assert_requested :get, api_url('/subjects?subject_set_id=2376')
    end
  end

  describe '#retire_subject' do
    let(:client) { application_client }

    it 'retires a subject' do
      retirement = client.retire_subject(688, 11937, reason: 'other')
      expect(retirement).to be_truthy
    end
  end
end
