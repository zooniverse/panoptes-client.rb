
module Panoptes
  class Client
    module ProjectPreferences
      def project_preferences(id)
        response = panoptes.get("project_preferences/#{id}")
        response.fetch("project_preferences").first
      end

      def user_project_preferences(user_id, project_id)
        response = panoptes.get("project_preferences", {
          user_id: user_id,
          project_id: project_id
        })
        response.fetch("project_preferences").first
      end

      def promote_user_to_workflow(user_id, project_id, workflow_id)
        id = panoptes.get("project_preferences", {
          user_id: user_id,
          project_id: project_id
        }).fetch("project_preferences").first["id"]

        response = panoptes.connection.get("/api/project_preferences/#{id}")
        etag = response.headers["ETag"]

        panoptes.put("project_preferences/#{id}", {
          project_preferences: { settings: { workflow_id: workflow_id } }
        }, etag: etag)
      end
    end
  end
end
