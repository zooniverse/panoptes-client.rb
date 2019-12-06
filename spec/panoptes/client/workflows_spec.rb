# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Workflows, :vcr do
  describe '#workflow' do
    let(:client) { unauthenticated_client }

    it 'returns a workflow given the id' do
      workflow = client.workflow(1364)
      expect(workflow['id']).to eq('1364')
      assert_requested :get, api_url('/workflows/1364')
    end
  end

  describe '#create_workflow' do
    let(:client) { user_client }

    it 'creates a workflow' do
      workflow = client.create_workflow(
        display_name: 'panoptes-client.rb test',
        primary_language: 'en',
        first_task: 'init',
        tasks: { 'T1' => { 'help' => '', 'type' => 'single', 'answers' => [{ 'next' => 'T2', 'label' => 'Yes' }, { 'label' => 'No' }], 'question' => 'Would you like to draw something?', 'required' => true }, 'T2' => { 'help' => '', 'type' => 'drawing', 'tools' => [], 'instruction' => 'Explain what to draw.' }, 'init' => { 'type' => 'single', 'answers' => [{ 'label' => 'Yes' }], 'question' => 'Is this a question?' } },
        links: { project: 813 }
      )
      expect(workflow['id']).to be
      assert_requested :post, api_url('/workflows')
    end
  end

  describe '#add_subject_set_to_workflow' do
    let(:client) { user_client }
    it 'adds subject set to workflow' do
      client.add_subject_set_to_workflow(2882, 4398)
      assert_requested :post, api_url('/workflows/2882/links/subject_sets')
    end
  end
end
