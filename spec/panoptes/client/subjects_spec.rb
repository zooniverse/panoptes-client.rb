# frozen_string_literal: true

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

  describe '#subject' do
    let(:client) { application_client }

    it 'returns true if a subject is accessible to a project' do
      result = client.subject(72_850, project_id: 1315)
      expect(result).not_to be(nil)
      expect(result['id']).to eq('72850')
      assert_requested :get, api_url('/subjects/72850?project_id=1315')
    end

    it 'returns false if a subject is inaccessible to a project' do
      result = client.subject(72_850, project_id: 1)
      expect(result).to be(nil)
      assert_requested :get, api_url('/subjects/72850?project_id=1')
    end

    it 'raises an error if too many subjects are returned' do
      expect do
        client.subject(72_850, project_id: 1315)
      end.to raise_error(StandardError)

      assert_requested :get, api_url('/subjects/72850?project_id=1315')
    end
  end

  describe '#retire_subject' do
    let(:client) { application_client }

    it 'retires a subject' do
      retirement = client.retire_subject(688, 11_937, reason: 'other')
      expect(retirement).to be_truthy
    end
  end
end
