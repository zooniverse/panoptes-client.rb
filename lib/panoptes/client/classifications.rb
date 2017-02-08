module Panoptes
  class Client
    module Classifications
      def get_subject_classifications(subject_id, workflow_id)
        panoptes.get("/classifications/project", {
          admin: true,
          workflow_id: workflow_id,
          subject_id: subject_id
        })
      end
    end
  end
end
