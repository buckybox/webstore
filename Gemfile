source 'https://rubygems.org'

gem 'rails'
gem 'sass-rails'
gem 'uglifier' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails' # Use CoffeeScript for .coffee assets and views
gem 'rails-html-sanitizer' # Use Rails Html Sanitizer for HTML sanitization

gem 'therubyracer' # JS runtime
gem 'jquery-rails' # Use jquery as the JavaScript library
# gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'jquery-turbolinks'

# Our additional Gems are listed below
gem 'secure_headers'
gem 'rails-i18n'
gem 'crazy_money'
gem 'ordinalize_full', require: 'ordinalize_full/integer'
gem 'super_recursive_open_struct'
gem 'buckybox-api'
gem 'fast_blank'
gem 'figaro'

gem 'redis' # for WebstorePersistence
gem 'hiredis' # https://github.com/redis/redis-rb#hiredis

gem 'haml-rails'
gem 'bootstrap-sass', '< 3' # TODO: upgrade to 3
gem 'autoprefixer-rails' # Add browser vendor prefixes automatically
gem 'select2-rails', '< 4' # TODO: https://github.com/select2/select2/blob/master/docs/announcements-4.0.html
gem 'leaflet-rails'

gem 'simple_form'
gem 'virtus'
gem 'draper'
gem 'naught'

# Optional Gems are listed below
gem 'unicorn'
# gem 'airbrake'
gem 'bugsnag'
gem 'newrelic_rpm'
# gem 'skylight'
# gem 'rack-mini-profiler'

group :development, :test do
  gem 'byebug', platform: :mri
  # gem 'web-console' # NOTE: doesn't seem to work properly in threaded environment
  gem 'better_errors'
  gem 'binding_of_caller' # to get REPL for better_errors
end

group :development do
  gem 'foreman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'simplecov', require: false
  gem 'brakeman', require: false
  gem 'cane', require: false
  gem 'discover-unused-partials', require: false
end

group :test do
  gem 'rspec-rails', require: false
  gem 'cucumber-rails', require: false
  gem 'capybara', require: false
  gem 'capybara-screenshot'
  gem 'poltergeist', require: false
  gem 'webmock', require: false
end
