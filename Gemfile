source 'https://rubygems.org'

gem 'rails', '4.2.0.beta1'
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.0' # Use CoffeeScript for .js.coffee assets and views
gem 'rails-html-sanitizer', '~> 1.0' # Use Rails Html Sanitizer for HTML sanitization

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jquery-turbolinks'
# gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password


# Our additional Gems are listed below
gem 'rails-i18n'
gem 'unicorn'
gem 'puma'
gem 'crazy_money'
gem 'ordinalize_full', require: 'ordinalize_full/integer'
gem 'super_recursive_open_struct'
gem 'buckybox-api', git: 'https://github.com/buckybox/buckybox-api-ruby.git'
gem 'fast_blank'
gem 'figaro'
gem 'analytical'

gem 'redis' # for WebstorePersistence
gem 'hiredis'  # https://github.com/redis/redis-rb#hiredis

gem 'haml-rails'
gem 'bootstrap-sass', '~> 2.3.2.2' # TODO: upgrade to 3
gem 'autoprefixer-rails' # Add browser vendor prefixes automatically
gem 'select2-rails', '>= 3.5.0'

gem 'simple_form',   '>= 3.1.0.rc2' # TODO: update to stable release when out
gem 'virtus',        '~> 1.0.1'
gem 'draper',        '~> 1.2.1'
gem 'naught',        '>= 1'

gem 'airbrake'
gem 'bugsnag'
# gem 'rack-mini-profiler'

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exceptions page and /console in development
  # gem 'web-console', '>= 2.0.0.beta2' # NOTE: doesn't seem to work properly in threaded environment
  gem 'better_errors'
  gem 'binding_of_caller' # to get REPL for better_errors

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
end

group :development do
  gem 'foreman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'i18n-spec', '>= 0.5.2', require: false
  gem 'simplecov', require: false
  gem 'brakeman', require: false
end

group :test do
  # gem 'cucumber-rails', require: false
  gem 'capybara', '~> 2.3.0', require: false # TODO: fix cukes for 2.4
  gem 'capybara-screenshot'
  gem 'poltergeist', require: false
  # gem 'guard', '>= 2'
  # gem 'guard-rspec', '>= 4'
  gem 'rspec-rails', '>= 3'
  # gem 'listen'
  # gem 'letter_opener'
end

group :staging do
  gem 'mail_safe'
end

