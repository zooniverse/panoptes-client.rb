# Panoptes::Client

[![Build Status](https://travis-ci.org/zooniverse/panoptes-client.rb.svg?branch=master)](https://travis-ci.org/zooniverse/panoptes-client.rb)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/zooniverse/panoptes-client.rb/)

## Installation

```ruby
gem 'panoptes-client'
```

## Usage

In general, this library is supposed to be a thin, flat layer over our [HTTP-based API](http://docs.panoptes.apiary.io/). All public API methods can be found on the `Client` object.

**A lot of methods are still missing. We've only just started with this wrapper. You can either issue a PR adding the one you need, or use the generic `get` / `post` methods on `Client`.**


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Alternatively use docker and docker-compose to get your dev env setup.

``` bash
docker-compose build # to build your dev docker image
docker-compose up # to run the tests in the dev container

# or run an interactive bash session in the dev container
docker-compose run --service-ports --rm panoptes-client bash
```

The test suite uses VCR to record HTTP requests, so if you're not making any new requests you should be fine with the existing cassettes. If you are, the test suite uses environment variables to pull in authentication credentials. You'll need to [create an OAuth application on staging](https://panoptes-staging.zooniverse.org/oauth/applications), and set the following env vars:

| Variable                   | Value |
-----------------------------|-------|
| `ZOONIVERSE_CLIENT_ID`     | The application id |
| `ZOONIVERSE_CLIENT_SECRET` | The application secret |
| `ZOONIVERSE_ACCESS_TOKEN`  | An OAuth access token for the API |

We recommend [Direnv](https://github.com/direnv/direnv) as good utility to allow you to specify environment variables per directory.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/panoptes-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

