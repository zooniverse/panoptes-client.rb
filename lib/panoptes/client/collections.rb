# frozen_string_literal: true

module Panoptes
  class Client
    module Collections
      def collection(collection_id)
        response = panoptes.get("/collections/#{collection_id}")
        response['collections'].first
      end

      def add_subjects_to_collection(collection_id, subject_ids)
        panoptes.post("/collections/#{collection_id}/links/subjects", subjects: subject_ids)
      end
    end
  end
end
