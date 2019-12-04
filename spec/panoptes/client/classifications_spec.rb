# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client::Classifications, :vcr do
  describe '#get_subject_classifications' do
    let(:client) { user_client }

    it 'gets some classifications' do
      client.get_subject_classifications(1234, 5678)
      path = '/classifications/project?admin=true&workflow_id=5678&subject_id=1234'
      assert_requested :get, api_url(path)
    end
  end

  describe '#get_user_classifications' do
    let(:client) { user_client }

    it 'gets some classifications' do
      result = client.get_user_classifications('1325464', 2218)
      path = '/classifications/project?admin=true&workflow_id=2218&user_id=1325464'
      assert_requested :get, api_url(path)
      expect(result['classifications'].count).to eq(2)
      expect(result['classifications'][0]['id']).to eq('88262')
    end
  end
end
