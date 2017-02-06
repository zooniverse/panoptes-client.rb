module Panoptes
  class Client
    module Collections
      def add_subjects_to_collection(collection_id, subject_ids)
        panoptes.post("/collections/#{collection_id}/links/subjects",subjects: subject_ids)
      end
    end
  end
end
