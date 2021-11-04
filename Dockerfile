FROM ruby:2.7-slim

WORKDIR /panoptes-client

RUN apt-get update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
        build-essential \
        # git is required for installing gems from git repos
        git \
        nano \
        vim

ADD ./Gemfile /panoptes-client/
ADD ./panoptes-client.gemspec /panoptes-client/
ADD ./lib/panoptes/client/version.rb /panoptes-client/lib/panoptes/client/
ADD .git/ /panoptes-client/

RUN bundle config --global jobs `cat /proc/cpuinfo | grep processor | wc -l | xargs -I % expr % - 1` && bundle install

ADD ./ /panoptes-client

CMD ["bundle", "exec", "rspec"]
