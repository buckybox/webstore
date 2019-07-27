# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 4.2"
gem "puma"
gem "sass-rails"
gem "uglifier" # Use Uglifier as compressor for JavaScript assets
gem "coffee-rails" # Use CoffeeScript for .coffee assets and views
gem "rails-html-sanitizer" # Use Rails Html Sanitizer for HTML sanitization

gem "therubyracer" # JS runtime
gem "jquery-rails" # Use jquery as the JavaScript library
# gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'jquery-turbolinks'

# Our additional Gems are listed below
gem "secure_headers", "< 4" # TODO: upgrade
gem "rails-i18n"
gem "crazy_money"
gem "ordinalize_full", require: "ordinalize_full/integer"
gem "buckybox-api" # to use the git version: git: "https://github.com/buckybox/buckybox-api-ruby"
gem "hashie", "3.4.4" # TODO: 3.4.6 is broken
gem "fast_blank"
gem "figaro"

gem "redis" # for WebstorePersistence
gem "hiredis" # https://github.com/redis/redis-rb#hiredis

gem "haml-rails"
gem "bootstrap-sass", "< 3" # TODO: upgrade to 3
gem "autoprefixer-rails" # Add browser vendor prefixes automatically
gem "select2-rails", "< 4" # TODO: https://github.com/select2/select2/blob/master/docs/announcements-4.0.html
gem "leaflet-rails"

gem "simple_form"
gem "virtus"
gem "draper"
gem "naught"

# Optional Gems are listed below
gem "bugsnag"

group :development, :test do
  gem "byebug", platform: :mri
  gem "better_errors"
  gem "binding_of_caller" # to get REPL for better_errors
end

group :development do
  gem "bundler-audit", require: false
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "simplecov", "< 0.15", require: false # TODO: upgrade when https://travis-ci.org/buckybox/webstore/builds/308318715 is resolved
  gem "coveralls", require: false
  gem "brakeman", require: false
end

group :test do
  gem "rspec-rails", require: false
  gem "cucumber-rails", require: false
  gem "capybara", require: false
  gem "capybara-screenshot"
  gem "poltergeist", require: false
  gem "webmock", require: false
  gem "vcr", require: false
end
