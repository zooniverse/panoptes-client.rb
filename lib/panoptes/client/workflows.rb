module Panoptes
  class Client
    module Workflows
      def workflow(workflow_id)
        response = get("/workflows/#{workflow_id}")
        response.fetch("workflows").find {|i| i.fetch("id").to_s == workflow_id.to_s }
      end

      def create_workflow(attributes)
        response = post("/workflows", workflows: attributes)
        response.fetch("workflows").first
      end
    end
  end
end
