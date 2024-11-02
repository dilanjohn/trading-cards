#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database setup
#bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup 