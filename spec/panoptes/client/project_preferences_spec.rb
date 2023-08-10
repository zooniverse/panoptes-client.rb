# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::ProjectPreferences, :vcr do
  describe '#project_preferences' do
    let(:client) { user_client }

    let(:pref_id) { 655_348 }
    let(:user_id) { 1_325_801 }
    let(:project_id) { 1710 }
    let(:workflow_id) { 9999 }

    it 'returns the preferences object by id' do
      prefs = client.project_preferences(pref_id)
      expect(prefs).not_to be_nil
      expect(prefs).to include('id' => pref_id.to_s)
      assert_requested :get, api_url("/project_preferences/#{pref_id}")
    end

    it 'returns the preferences object for a user in a project' do
      prefs = client.user_project_preferences(user_id, project_id)
      expect(prefs).not_to be_nil
      expect(prefs).to include('id' => pref_id.to_s)
      url = '/project_preferences?project_id=1710&user_id=1325801'
      assert_requested :get, api_url(url)
    end

    it 'promotes the user to the desired workflow' do
      client.set_user_workflow(user_id, project_id, workflow_id)
      prefs = client.user_project_preferences(user_id, project_id)

      expect(prefs).not_to be_nil
      settings = prefs.fetch('settings', {})
      expect(settings).to include('workflow_id' => workflow_id.to_s)
      assert_requested :put, api_url("/project_preferences/#{pref_id}")
    end

    context 'leveling up' do
      # Workflow IDs and levels are set in the VCR request fixtures.
      # Levels are stored in the workflow resource configurations.
      # Workflow 3333 is the current workflow (level 1) and 9999 is level 2.
      # Workflow 1111 is the lower level (0) no-op workflow.
      # None of these are real workflows.

      it 'levels up the user to the next workflow' do
        client.promote_user_to_workflow(user_id, project_id, workflow_id)
        prefs = client.user_project_preferences(user_id, project_id)

        expect(prefs).not_to be_nil
        settings = prefs.fetch('settings', {})
        expect(settings).to include('workflow_id' => workflow_id.to_s)
        assert_requested :put, api_url("/project_preferences/#{pref_id}")
      end

      it 'does not level the user up if the current workflow is higher' do
        lower_level_workflow = 1111
        client.promote_user_to_workflow(user_id, project_id, lower_level_workflow)
        prefs = client.user_project_preferences(user_id, project_id)

        expect(prefs).not_to be_nil
        settings = prefs.fetch('settings', {})
        expect(settings).to include('workflow_id' => workflow_id.to_s)
        expect(settings).not_to include('workflow_id' => lower_level_workflow.to_s)
        assert_requested :put, api_url("/project_preferences/#{pref_id}"), times: 0
      end
    end
  end
end
