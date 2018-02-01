require 'spec_helper'

describe Panoptes::Client::ProjectPreferences, :vcr do
  describe '#project_preferences' do
      let(:client) { user_client }

      let(:pref_id){ 655_348 }
      let(:user_id){ 1_325_801 }
      let(:project_id){ 1710 }
      let(:workflow_id){ 9999 }

      it 'returns the preferences object by id' do
        prefs = client.project_preferences(pref_id)
        expect(prefs).not_to be_nil
        expect(prefs).to include("id" => pref_id.to_s)
        assert_requested :get, api_url("/project_preferences/#{pref_id}")
      end

      it 'returns the preferences object for a user in a project' do
        prefs = client.user_project_preferences(user_id, project_id)
        expect(prefs).not_to be_nil
        expect(prefs).to include("id" => pref_id.to_s)
        assert_requested :get, api_url("/project_preferences?project_id=1710&user_id=1325801")
      end

      it 'promotes the user to the desired workflow' do
        client.promote_user_to_workflow(user_id, project_id, workflow_id)
        prefs = client.user_project_preferences(user_id, project_id)

        expect(prefs).not_to be_nil
        expect(prefs.fetch('settings', {})).to include("workflow_id" => workflow_id.to_s)
        assert_requested :put, api_url("/project_preferences/#{pref_id}")
      end
  end
end
