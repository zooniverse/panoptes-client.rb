require 'spec_helper'

describe Panoptes::Client::Projects do
  describe 'unauthenticated', :vcr do
    let(:client) { unauthenticated_client }

    it 'returns a list of projects' do
      projects = client.projects
      expect(projects).not_to be_empty
      assert_requested :get, api_url('/projects')
    end

    it 'returns projects scoped to a search name' do
      projects = client.projects(search: "galaxy")
      names = projects.map { |project| project["display_name"] }
      expect(names.all? { |name| name.downcase.include?("galaxy") }).to be_truthy
    end
  end
end
