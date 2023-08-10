# frozen_string_literal: true

module Panoptes
  class Client
    module ProjectPreferences
      def project_preferences(id)
        response = panoptes.get("project_preferences/#{id}")
        response.fetch('project_preferences').first
      end

      def user_project_preferences(user_id, project_id)
        response = panoptes.get('project_preferences',
                                user_id: user_id,
                                project_id: project_id)
        response.fetch('project_preferences').first
      end

      def promote_user_to_workflow(user_id, project_id, workflow_id)
        project_pref = panoptes.get('project_preferences',
                          user_id: user_id,
                          project_id: project_id).fetch('project_preferences').first
        id = project_pref['id']
        workflow_id_current = project_pref['settings']['workflow_id']

        response = panoptes.connection.get("/api/project_preferences/#{id}")
        etag = response.headers['ETag']

        workflow_target = panoptes.get("/workflows/#{workflow_id}").fetch('workflows').first
        level_target = workflow_target['configuration']['level'].to_i

        workflow_current = panoptes.get("/workflows/#{workflow_id_current}").fetch('workflows').first
        level_current = workflow_current['configuration']['level'].to_i

        if level_target > level_current
          panoptes.put("project_preferences/#{id}", {
                         project_preferences: { settings: { workflow_id: workflow_id } }
                       }, etag: etag)
        end
      end

      def set_user_workflow(user_id, project_id, workflow_id)
        id = panoptes.get('project_preferences',
                          user_id: user_id,
                          project_id: project_id).fetch('project_preferences').first['id']

        response = panoptes.connection.get("/api/project_preferences/#{id}")
        etag = response.headers['ETag']

        panoptes.put("project_preferences/#{id}", {
                       project_preferences: { settings: { workflow_id: workflow_id } }
                     }, etag: etag)
      end
    end
  end
end
