# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Cellect, :vcr do
  let(:client) { unauthenticated_client }

  describe '#cellect_workflows' do
    subject { client.cellect_workflows }

    it 'should return a list of workflows' do
      expect(subject).not_to be_empty
      assert_requested :get, "#{test_url}/cellect/workflows"
    end
  end

  describe '#cellect_subjects' do
    subject { client.cellect_subjects(72) }

    it 'should return a list of workflows' do
      expect(subject).not_to be_empty
      assert_requested :get, "#{test_url}/cellect/subjects?workflow_id=72"
    end
  end
end
