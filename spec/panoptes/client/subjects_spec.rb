require 'spec_helper'

describe Panoptes::Client::Subjects, :vcr do
  describe '#retire_subject' do
    let(:client) { application_client }

    it 'retires a subject' do
      retirement = client.retire_subject(688, 11937, reason: 'other')
      expect(retirement).to be_truthy
    end
  end
end
