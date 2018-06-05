require 'spec_helper'

describe Panoptes::Client::Projects, :vcr do
  describe 'unauthenticated' do
    let(:client) { unauthenticated_client }

    it 'returns a list of projects' do
      projects = client.projects
      expect(projects).not_to be_empty
      assert_requested :get, api_url('/projects')
    end

    it 'fetches a project by id' do
      project = client.project(405)
      expect(project).not_to be_empty
      assert_requested :get, api_url('/projects/405')
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
        "href"=>"/projects/813/classifications_export",
        "content_type"=>"text/csv",
        "media_type"=>"project_classifications_export",
        "external_link"=>false,
        "links"=>{"linked"=>{"href"=>"/projects/813", "id"=>"813", "type"=>"projects"}}
      })
      expect(export["src"]).to include("https://panoptes-uploads.zooniverse.org/staging/project_classifications_export/")
    end
  end

  describe '#create_subjects_export' do
    let(:client) { user_client }

    it 'returns the export medium hash' do
      export = client.create_subjects_export(813)

      expect(export).to include({
        "href"=>"/projects/813/subjects_export",
        "content_type"=>"text/csv",
        "media_type"=>"project_subjects_export",
        "external_link"=>false,
        "links"=>{"linked"=>{"href"=>"/projects/813", "id"=>"813", "type"=>"projects"}}
      })
      expect(export["src"]).to include("https://panoptes-uploads.zooniverse.org/staging/project_subjects_export/")
    end
  end

  describe '#create_workflows_export' do
    let(:client) { user_client }

    it 'returns the export medium hash' do
      export = client.create_workflows_export(813)

      expect(export).to include({
        "href"=>"/projects/813/workflows_export",
        "content_type"=>"text/csv",
        "media_type"=>"project_workflows_export",
        "external_link"=>false,
        "links"=>{"linked"=>{"href"=>"/projects/813", "id"=>"813", "type"=>"projects"}}
      })
      expect(export["src"]).to include("https://panoptes-uploads.zooniverse.org/staging/project_workflows_export/")
    end
  end

  describe '#create_workflow_contents_export' do
    let(:client) { user_client }

    it 'returns the export medium hash' do
      export = client.create_workflow_contents_export(813)

      expect(export).to include({
        "href"=>"/projects/813/workflow_contents_export",
        "content_type"=>"text/csv",
        "media_type"=>"project_workflow_contents_export",
        "external_link"=>false,
        "links"=>{"linked"=>{"href"=>"/projects/813", "id"=>"813", "type"=>"projects"}}
      })
      expect(export["src"]).to include("https://panoptes-uploads.zooniverse.org/staging/project_workflow_contents_export/")
    end
  end

  describe '#create_aggregations_export' do
    let(:client) { user_client }

    it 'returns the export medium hash' do
      export = client.create_aggregations_export(813)

      expect(export).to include({
        "href"=>"/projects/813/aggregations_export",
        "content_type"=>"application/x-gzip",
        "media_type"=>"project_aggregations_export",
        "external_link"=>false,
        "links"=>{"linked"=>{"href"=>"/projects/813", "id"=>"813", "type"=>"projects"}}
      })
      expect(export["src"]).to include("https://panoptes-uploads.zooniverse.org/staging/project_aggregations_export/")
    end
  end
end
