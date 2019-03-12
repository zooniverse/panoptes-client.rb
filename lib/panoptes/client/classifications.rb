# frozen_string_literal: true

module Panoptes
  class Client
    module Classifications
      def get_subject_classifications(subject_id, workflow_id)
        panoptes.paginate('/classifications/project', {
                            admin: true,
                            workflow_id: workflow_id,
                            subject_id: subject_id
                          }, resource: 'classifications')
      end

      def get_user_classifications(user_id, workflow_id)
        panoptes.paginate('/classifications/project', {
                            admin: true,
                            workflow_id: workflow_id,
                            user_id: user_id
                          }, resource: 'classifications')
      end
    end
  end
end
