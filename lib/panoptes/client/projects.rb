module Panoptes
  class Client
    module Projects
      def projects(search: nil)
        params = {}
        params[:search] = search if search

        get("/projects", params)["projects"]
      end
    end
  end
end
