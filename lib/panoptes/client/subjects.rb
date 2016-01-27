module Panoptes
  class Client
    module Subjects
      def retire_subject(workflow_id, subject_id)
        post("/workflows/#{workflow_id}/retired_subjects", {
          admin: true,
          subject_id: subject_id
        })
      end
    end
  end
end
