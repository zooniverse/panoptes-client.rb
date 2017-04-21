require 'spec_helper'
require 'panoptes/endpoints/base_endpoint'

describe Panoptes::Endpoints::BaseEndpoint do
  let(:params_client) {
    described_class.new(
      url: 'http://example.com',
      params: {:admin => true}
    )
  }

  let(:params_connection) {
    params_client.connection
  }

  it 'can be constructed without params' do
    described_class.new(url: 'http://example.com')
  end

  it 'can be constructed with params' do
    endpoint = params_client
    expect(endpoint.params).to include({:admin => true})
  end

  it 'uses the params value' do
    connection = params_connection

    expect(connection).not_to be(nil)
    expect(connection.params).to include({"admin" => true})
  end
end
