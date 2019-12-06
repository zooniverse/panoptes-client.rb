# frozen_string_literal: true

module Panoptes
  class Client
    module SubjectSets
      def subject_set(subject_set_id)
        response = panoptes.get("/subject_sets/#{subject_set_id}")
        response.fetch('subject_sets').find { |i| i.fetch('id').to_s == subject_set_id.to_s }
      end

      def create_subject_set(attributes)
        response = panoptes.post('/subject_sets', subject_sets: attributes)
        response.fetch('subject_sets').first
      end

      def update_subject_set(subject_set_id, attributes)
        response = panoptes.connection.get("/api/subject_sets/#{subject_set_id}")
        etag = response.headers['ETag']

        response = panoptes.put("/subject_sets/#{subject_set_id}", { subject_sets: attributes }, etag: etag)
        response.fetch('subject_sets').first
      end

      def add_subjects_to_subject_set(subject_set_id, subject_ids)
        response = panoptes.post("/subject_sets/#{subject_set_id}/links/subjects", subjects: subject_ids)
        true
      end
    end
  end
end
