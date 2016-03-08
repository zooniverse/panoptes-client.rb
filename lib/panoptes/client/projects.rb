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

        paginate("/projects", params)["projects"]
      end

      # Starts a background process to generate a new CSV export of all the classifications
      # in the project.
      #
      # @param project_id [Integer] the id of the project to export
      # @return [Hash] the medium information where the project will be stored when it's generated
      def create_classifications_export(project_id)
        params = {
          media: {
            content_type: "text/csv",
            metadata: { recipients: [] }
          }
        }

        post("/projects/#{project_id}/classifications_export", params)["media"].first
      end
    end
  end
end
