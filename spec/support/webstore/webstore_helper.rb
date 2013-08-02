require 'spec_helper'
require_relative 'setup_webstore_helpers'
require_relative 'setup_webstore_macros'

RSpec.configure do |config|
  config.include Webstore::SetupWebstoreHelpers,  type: :feature
  config.extend Webstore::SetupWebstoreMacros,    type: :feature
end

RSpec.configure do |config|
# http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
end

