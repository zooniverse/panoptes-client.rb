module Panoptes
  class Client
    module SubjectSets
      def subject_set(subject_set_id)
        response = get("/subject_sets/#{subject_set_id}")
        response.fetch("subject_sets").find {|i| i.fetch("id").to_s == subject_set_id.to_s }
      end

      def create_subject_set(attributes)
        response = post("/subject_sets", subject_sets: attributes)
        response.fetch("subject_sets").first
      end
    end
  end
end
