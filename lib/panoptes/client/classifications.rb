module Panoptes
  class Client
    module Classifications
      def get_subject_classifications(subject_id, workflow_id)
        panoptes.paginate("/classifications/project", {
          admin: true,
          workflow_id: workflow_id,
          subject_id: subject_id
        }, resource: "classifications")
      end
    end
  end
end
