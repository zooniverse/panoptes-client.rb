# frozen_string_literal: true

module Panoptes
  class Client
    module Workflows
      def workflow(workflow_id)
        response = panoptes.get("/workflows/#{workflow_id}")
        response.fetch('workflows').find { |i| i.fetch('id').to_s == workflow_id.to_s }
      end

      def create_workflow(attributes)
        response = panoptes.post('/workflows', workflows: attributes)
        response.fetch('workflows').first
      end

      def add_subject_set_to_workflow(workflow_id, subject_set_id)
        panoptes.post("/workflows/#{workflow_id}/links/subject_sets", subject_sets: subject_set_id)
      end
    end
  end
end
