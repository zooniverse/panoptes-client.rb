# frozen_string_literal: true

require 'faraday'

module Panoptes
  class Client
    module Cellect
      # Fetches all cellect-enabled, launched workflows.
      #
      # @return [Hash] the list of workflows
      def cellect_workflows
        cellect.get '/workflows'
      end

      # Fetches all active subjects for a cellect-enabled workflow.
      #
      # @param workflow_id [Integer] the id of the workflow
      # @return [Hash] the list of subjects
      def cellect_subjects(workflow_id)
        cellect.get '/subjects', workflow_id: workflow_id
      end
    end
  end
end
