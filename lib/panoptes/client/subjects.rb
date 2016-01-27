module Panoptes
  class Client
    module Subjects
      # Retire a subject for a workflow
      #
      # @param workflow_id [Integer] the ID of a workflow
      # @param subject_id  [Integer] the ID of a subject associated with that workflow (through one of the assigned subject_sets)
      # @return nothing
      def retire_subject(workflow_id, subject_id)
        post("/workflows/#{workflow_id}/retired_subjects", {
          admin: true,
          subject_id: subject_id
        })
      end
    end
  end
end
