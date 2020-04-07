# frozen_string_literal: true

module Panoptes
  class Client
    module Collections
      def collection(collection_id)
        response = panoptes.get("/collections/#{collection_id}")
        response.fetch('collections')
                .find { |i| i.fetch('id').to_s == collection_id.to_s }
      end

      def add_subjects_to_collection(collection_id, subject_ids)
        panoptes.post("/collections/#{collection_id}/links/subjects", subjects: subject_ids)
      end
    end
  end
end
