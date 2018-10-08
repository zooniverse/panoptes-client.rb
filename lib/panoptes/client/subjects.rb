module Panoptes
  class Client
    module Subjects
      # Get list of subjects
      #
      # @param subject_set_id [Integer] filter by subject set
      # @return list of subjects
      def subjects(subject_set_id: nil, workflow_id: nil)
        query = {}
        query[:subject_set_id] = subject_set_id if subject_set_id
        query[:workflow_id] = workflow_id if workflow_id

        raise 'Must filter on at least one of subject_set_id, workflow_id' if query.empty?

        response = panoptes.paginate("/subjects", query)
        response.fetch("subjects")
      end

      # Fetch a subject given filters (including permissions)
      #
      # @param subject_id [Integer]
      # @param project_id [Integer]
      # @return nil or the subject
      def subject(subject_id, project_id: nil)
        query = {}
        query[:project_id] = project_id if project_id

        response = panoptes.get("/subjects/#{subject_id}", query)
        if response.fetch('subjects', []).count > 1
          raise StandardError.new 'Unexpectedly many subjects returned'
        end

        response.fetch('subjects', []).fetch(0, nil)
      end

      # Retire a subject for a workflow
      #
      # @todo Add this endpoint to the Apiary docs and add a see-reference here.
      # @param workflow_id [Integer] the ID of a workflow
      # @param subject_id  [Integer] the ID of a subject associated with that workflow (through one of the assigned subject_sets)
      # @return nothing
      def retire_subject(workflow_id, subject_id, reason: nil)
        panoptes.post("/workflows/#{workflow_id}/retired_subjects", {
          admin: true,
          subject_id: subject_id,
          retirement_reason: reason
        })
        true
      end
    end
  end
end
