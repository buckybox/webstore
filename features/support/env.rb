# frozen_string_literal: true

require 'simplecov' if ENV['COVERAGE']

require 'cucumber/rails'
require 'cucumber/rspec/doubles' # https://github.com/cucumber/cucumber/wiki/Mocking-and-Stubbing-with-Cucumber
ActionController::Base.allow_rescue = true

require 'capybara-screenshot/cucumber'
Capybara.save_and_open_page_path = Rails.root.join("tmp")
Capybara.asset_host = "http://localhost:3000"

# JavaScript driver
require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist

# JavaScript Debug driver
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app,
    debug: false,
    js_errors: true,
    timeout: 300,
  )
end

Capybara.javascript_driver = :poltergeist_debug
