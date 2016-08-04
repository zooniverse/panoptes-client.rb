$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'panoptes-client'

require 'webmock/rspec'
require 'vcr'
require 'timecop'
require 'pry'
require 'openssl'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<ACCESS_TOKEN>") { test_access_token }
  config.filter_sensitive_data("<CLIENT_ID>")    { test_client_id }
  config.filter_sensitive_data("<CLIENT_SECRET") { test_client_secret }
end

def fake_keypair
  @fake_keypair ||= OpenSSL::PKey::RSA.generate 2048
end

def fake_public_key_path
  @fake_public_key_path ||= Tempfile.new('panoptes-client-pubkey').tap do |file|
    file.write(fake_keypair.public_key.to_s)
    file.close
  end
  @fake_public_key_path.path
end

def fake_access_token
  JWT.encode({"id" => 1323869}, fake_keypair, 'RS512')
end

def test_url;           ENV.fetch("ZOONIVERSE_URL",             'https://panoptes-staging.zooniverse.org'); end
def test_talk_url;      ENV.fetch("ZOONIVERSE_TALK_URL",        'https://talk-staging.zooniverse.org'); end
def test_access_token;  ENV.fetch("ZOONIVERSE_ACCESS_TOKEN",    fake_access_token); end
def test_public_key;    ENV.fetch("ZOONIVERSE_PUBLIC_KEY_PATH", fake_public_key_path); end
def test_client_id;     ENV.fetch("ZOONIVERSE_CLIENT_ID",       'x'*64); end
def test_client_secret; ENV.fetch("ZOONIVERSE_CLIENT_SECRET",   'x'*64); end

def unauthenticated_client
  Panoptes::Client.new(env: :test)
end

def application_client
  Panoptes::Client.new(
    env: :test,
    auth: {client_id: test_client_id, client_secret: test_client_secret}
  )
end

def user_client
  Panoptes::Client.new(
    env: :test,
    auth: {token: test_access_token},
    public_key_path: test_public_key,
  )
end

def talk_client
  user_client
end

def api_url(path)
  test_url + "/api" + path
end

def talk_api_url(path)
  test_talk_url + path
end
