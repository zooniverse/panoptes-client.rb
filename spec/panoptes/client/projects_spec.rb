require 'spec_helper'

describe Panoptes::Client::Projects, :vcr do
  describe 'unauthenticated' do
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

  describe '#create_classifications_export' do
    let(:client) { user_client }

    it 'returns the export medium hash' do
      export = client.create_classifications_export(813)

      expect(export).to include({
        "id"=>"38663", 
        "href"=>"/projects/813/classifications_export", 
        "content_type"=>"text/csv", 
        "media_type"=>"project_classifications_export", 
        "external_link"=>false, 
        "metadata"=>{"recipients"=>[]}, 
        "links"=>{"linked"=>{"href"=>"/projects/813", "id"=>"813", "type"=>"projects"}}
      })
      expect(export["src"]).to include("https://zooniverse-static.s3.amazonaws.com/panoptes-uploads.zooniverse.org/staging/project_classifications_export/")
    end
  end
end
