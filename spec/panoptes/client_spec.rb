# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Client do
  it 'has a version number' do
    expect(Panoptes::Client::VERSION).not_to be nil
  end
end
