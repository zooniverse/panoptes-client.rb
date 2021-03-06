# frozen_string_literal: true

module Panoptes
  class Client
    module Projects
      # Fetches the list of all projects.
      #
      # @see http://docs.panoptes.apiary.io/#reference/projects/project-collection/list-all-projects
      # @param search [String] filter projects using full-text search on names (amongst others)
      # @return [Array] the list of projects
      def projects(search: nil)
        params = {}
        params[:search] = search if search

        panoptes.paginate('/projects', params)['projects']
      end

      # Fetches the specified project
      #
      # @see http://docs.panoptes.apiary.io/#reference/projects/project-collection/list-all-projects
      # @param project_id [String] The ID of the project to be retrieved
      # @return [Hash] The requested project
      def project(project_id)
        response = panoptes.get("/projects/#{project_id}")
        response.fetch('projects').find { |i| i.fetch('id').to_s == project_id.to_s }
      end

      # Starts a background process to generate a new CSV export of all the classifications in the project.
      #
      # @param project_id [Integer] the id of the project to export
      # @return [Hash] the medium information where the export will be stored when it's generated
      def create_classifications_export(project_id)
        params = export_params('text/csv')
        path = export_path(project_id, 'classifications_export')
        panoptes.post(path, params)['media'].first
      end

      # Starts a background process to generate a new CSV export of all the subjects in the project.
      #
      # @param project_id [Integer] the id of the project to export
      # @return [Hash] the medium information where the export will be stored when it's generated
      def create_subjects_export(project_id)
        params = export_params('text/csv')
        path = export_path(project_id, 'subjects_export')
        panoptes.post(path, params)['media'].first
      end

      # Starts a background process to generate a new CSV export of all the workflows in the project.
      #
      # @param project_id [Integer] the id of the project to export
      # @return [Hash] the medium information where the export will be stored when it's generated
      def create_workflows_export(project_id)
        params = export_params('text/csv')
        path = export_path(project_id, 'workflows_export')
        panoptes.post(path, params)['media'].first
      end

      # Starts a background process to generate a new CSV export of all the workflow_contents in the project.
      #
      # @param project_id [Integer] the id of the project to export
      # @return [Hash] the medium information where the export will be stored when it's generated
      def create_workflow_contents_export(project_id)
        params = export_params('text/csv')
        path = export_path(project_id, 'workflow_contents_export')
        panoptes.post(path, params)['media'].first
      end

      # Starts a background process to generate a new CSV export of the aggretation results of the project.
      #
      # @param project_id [Integer] the id of the project to export
      # @return [Hash] the medium information where the export will be stored when it's generated
      def create_aggregations_export(project_id)
        params = export_params('application/x-gzip')
        path = export_path(project_id, 'aggregations_export')
        panoptes.post(path, params)['media'].first
      end

      private

      def export_params(content_type)
        { media: { content_type: content_type, metadata: { recipients: [] } } }
      end

      def export_path(project_id, export_type)
        "/projects/#{project_id}/#{export_type}"
      end
    end
  end
end
