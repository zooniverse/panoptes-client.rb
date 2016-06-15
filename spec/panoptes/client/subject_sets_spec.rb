require 'spec_helper'

describe Panoptes::Client::SubjectSets, :vcr do
  describe '#subject_set' do
    let(:client) { unauthenticated_client }

    it 'returns a subject_set given the id' do
      subject_set = client.subject_set(2376)
      expect(subject_set['id']).to eq('2376')
      assert_requested :get, api_url('/subject_sets/2376')
    end
  end

  describe '#create_subject_set' do
    let(:client) { user_client }

    it 'creates a subject_set' do
      subject_set = client.create_subject_set(
        display_name: "panoptes-client.rb #{Time.now.to_i}",
        links: {project: 813}
      )
      expect(subject_set['id']).to be
      assert_requested :post, api_url('/subject_sets')
    end
  end

  describe "#update_subject_set" do
    let(:client) { user_client }

    it 'updates a subject_set' do
      subject_set = client.create_subject_set(display_name: "panoptes-client.rb #{Time.now.to_i}", links: {project: 813, subjects: [11932]} )
      subject_set_id = subject_set['id']

      client.update_subject_set(subject_set_id, links: {subjects: [3156]})
      assert_requested :put, api_url("/subject_sets/#{subject_set_id}")

      subjects = client.subjects(subject_set_id: subject_set_id)
      expect(subjects.map {|i| i["id"] }).to eq(["3156"])
    end
  end

  describe "#add_subjects_to_subject_set" do
    let(:client) { user_client }

    it 'adds subjects' do
      subject_set = client.create_subject_set(display_name: "panoptes-client.rb #{Time.now.to_i}", links: {project: 813, subjects: [11932]} )
      subject_set_id = subject_set['id']

      client.add_subjects_to_subject_set(subject_set_id, [3156])
      assert_requested :post, api_url("/subject_sets/#{subject_set_id}/links/subjects")

      subjects = client.subjects(subject_set_id: subject_set_id)
      expect(subjects.size).to eq(2)
    end
  end
end
