#!/usr/bin/env sh

git checkout netlify-stats && git pull --ff-only
git checkout main && git pull --ff-only

bundle exec --gemfile collect-stats/Gemfile collect-stats/collect-stats.rb

git checkout main
