source 'https://rubygems.org'

gem 'rails', '4.2.0.beta2'
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0' # Use CoffeeScript for .coffee assets and views
gem 'rails-html-sanitizer', '~> 1.0' # Use Rails Html Sanitizer for HTML sanitization

gem 'therubyracer' # JS runtime
gem 'jquery-rails' # Use jquery as the JavaScript library
# gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'jquery-turbolinks'
# gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password

# Our additional Gems are listed below
gem 'rails-i18n'
gem 'crazy_money'
gem 'ordinalize_full', require: 'ordinalize_full/integer'
gem 'super_recursive_open_struct'
gem 'buckybox-api'
gem 'fast_blank'
gem 'figaro'
gem 'analytical'

gem 'redis' # for WebstorePersistence
gem 'hiredis'  # https://github.com/redis/redis-rb#hiredis

gem 'haml-rails'
gem 'bootstrap-sass', '~> 2.3.2.2' # TODO: upgrade to 3
gem 'autoprefixer-rails' # Add browser vendor prefixes automatically
gem 'select2-rails'

gem 'simple_form', '>= 3.1.0.rc2' # TODO: update to stable release when out
gem 'virtus'
gem 'draper'
gem 'naught'

# Optional Gems are listed below
gem 'puma'
# gem 'unicorn'
# gem 'airbrake'
gem 'bugsnag'
# gem 'rack-mini-profiler'

group :development, :test do
  gem 'byebug', platform: :mri
  # gem 'web-console', '>= 2.0.0.beta4' # NOTE: doesn't seem to work properly in threaded environment
  gem 'better_errors'
  gem 'binding_of_caller' # to get REPL for better_errors
end

group :development do
  gem 'foreman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'i18n-spec', '>= 0.5.2', require: false
  gem 'simplecov', require: false
  gem 'brakeman', require: false
  gem 'cane', require: false
  gem 'discover-unused-partials', require: false
end

group :test do
  gem 'rspec-rails', '>= 3', require: false
  gem 'cucumber-rails', require: false
  gem 'capybara', '~> 2.3.0', require: false # TODO: fix cukes for 2.4
  gem 'capybara-screenshot'
  gem 'poltergeist', require: false
  gem 'webmock', require: false
  # gem 'guard', '>= 2'
  # gem 'guard-rspec', '>= 4'
  # gem 'listen'
  # gem 'letter_opener'
end

group :staging do
  # gem 'mail_safe'
end
