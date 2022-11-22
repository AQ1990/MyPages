FROM ruby:3.1-alpine
RUN apk updated
RUN apk add --no-cache build-base gcc cmake git
RUN gem update bundler && gem install bundler jekyll