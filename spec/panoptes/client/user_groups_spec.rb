require 'spec_helper'

describe Panoptes::Client::UserGroups do
  describe 'as a user', :vcr do
    let(:client) { user_client }

    it 'lists user groups' do
      user_groups = client.user_groups
      expect(user_groups).not_to be_empty
      assert_requested :get, api_url('/user_groups')
    end

    it 'creates a new group' do
      user_group = client.create_user_group("panoptes-client-rb-test-group")
      expect(user_group["name"]).to eq("panoptes-client-rb-test-group")
      assert_requested :post, api_url('/user_groups')
    end

    it 'joins a group' do
      membership = client.join_user_group("1325971", "1323869", join_token: '14b9c70f23f91cc7')
      expect(membership["links"]["user_group"]).to eq("1325971")
      expect(membership["links"]["user"]).to eq("1323869")
      assert_requested :post, api_url('/memberships')
    end

    it 'removes someone from a group' do
      client.remove_user_from_user_group("1325971", "1323570")
      assert_requested :delete, api_url('/user_groups/1325971/links/users/1323570')
    end

    it 'deletes a user group' do
      client.delete_user_group("1325971")
      assert_requested :delete, api_url('/user_groups/1325971')
    end
  end
end
