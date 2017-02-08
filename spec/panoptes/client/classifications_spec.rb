require 'spec_helper'

describe Panoptes::Client::Classifications, :vcr do
  describe '#get_subject_classifications' do
    let(:client){ user_client }

    it 'gets some classifications' do
      client.get_subject_classifications(1234, 5678)
      assert_requested :get, api_url("/classifications/project?admin=true&workflow_id=5678&subject_id=1234")
    end
  end
end
