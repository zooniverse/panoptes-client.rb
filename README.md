# Panoptes::Client

[![Build Status](https://github.com/zooniverse/panoptes-client.rb/actions/workflows/run_tests_CI.yml/badge.svg?)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/zooniverse/panoptes-client.rb/)

## Installation

```ruby
gem 'panoptes-client'
```

## Usage

In general, this library is supposed to be a thin, flat layer over our [HTTP-based API](http://docs.panoptes.apiary.io/). All public API methods can be found on the `Client` object.

**A lot of methods are still missing. We've only just started with this wrapper. You can either issue a PR adding the one you need, or use the generic `get` / `post` methods on `Client`.**


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

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

## Publishing

Follow these steps for publishing changes to the panoptes-client.rb ruby gem.

1. Make sure changes have been outlined in CHANGELOG.md, and version has been updated in lib/panoptes/client/version.rb. Reference [Semantic Versioning](https://semver.org/) for guidance on how to update the version number.
2. Tag a release when your PR has been merged into master. Use [this guide](https://help.github.com/en/github/administering-a-repository/managing-releases-in-a-repository) for reference on how to create release tags. Set the version number (e.g. v1.1.1) as the tag name. Select the master branch as the target branch. In the release description, list out the changes that have been made just as you did in CHANGELOG.md. Do not select pre-release unless it’s not yet ready for production, and then click ‘Publish Release’.
3. Once the release tag is set, check out the release branch locally and test to make sure everything is working as expected, run tests and make sure they pass. Use the following command to check out a branch via its tag: `git checkout tags/<tag>`
4. Create the package by running `rake build`. This will build the new version of the panoptes gem (e.g. panoptes-client-1.1.1.gem) into the pkg directory. Once you’ve done this, run `bundler console` to make sure everything works as expected. For more details on packaging and distributing ruby gems, check out [this article](https://www.digitalocean.com/community/tutorials/how-to-package-and-distribute-ruby-applications-as-a-gem-using-rubygems).
5. To publish the gem, use the command `[sudo] gem push [gem file]`. You’ll need to enter your rubygem.org credentials. Make sure you are one of the owners of the gem, or else you will not have permission to publish. You should see the version updated shortly on https://rubygems.org/gems/panoptes-client. And that’s it!


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

