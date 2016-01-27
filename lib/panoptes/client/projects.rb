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
    end
  end
end
