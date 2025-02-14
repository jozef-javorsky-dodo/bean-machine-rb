# Use the official Ruby image.
# https://hub.docker.com/_/ruby

FROM ruby:3.2-buster

WORKDIR /src

COPY Gemfile Gemfile.lock ./
COPY . ./

ENV BUNDLE_FROZEN=true

RUN gem install bundler && bundle config set --local without 'test'
RUN bundle install

CMD ["ruby", "./bean_machine.rb"]
