# frozen_string_literal: true

require 'simplecov' if ENV['COVERAGE']

require 'cucumber/rails'
# require 'cucumber/rspec/doubles' # https://github.com/cucumber/cucumber/wiki/Mocking-and-Stubbing-with-Cucumber
ActionController::Base.allow_rescue = true

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  options = { js_errors: false } # FIXME
  Capybara::Poltergeist::Driver.new(app, options)
end

require 'capybara-screenshot/cucumber'
# Capybara.asset_host = "http://localhost:3000"

require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = BuckyBox::API.fixtures_path
  c.hook_into :webmock
  c.default_cassette_options = { record: :none }
  c.ignore_localhost = true
end

Dir.glob(File.join(BuckyBox::API.fixtures_path, "*.yml")).each do |file|
  cassette = File.basename(file, ".yml")
  puts "Loading cassette #{cassette}"
  VCR.insert_cassette cassette
end

Dir[Rails.root.join("spec/support/capybara/**/*.rb")].each { |f| require f }
