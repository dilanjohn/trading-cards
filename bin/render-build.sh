#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle config set --local deployment 'true'
bundle config set --local without 'development test'
bundle install

# Build commands
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Database setup
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup 