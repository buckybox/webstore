# frozen_string_literal: true

require "simplecov" if ENV["COVERAGE"]

require "cucumber/rails"
ActionController::Base.allow_rescue = true

# Capybara.javascript_driver = :selenium_chrome

require "capybara-screenshot/cucumber"

require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = BuckyBox::API.fixtures_path
  c.hook_into :webmock
  c.default_cassette_options = { record: :none, allow_playback_repeats: true }
  c.ignore_localhost = true
end

Dir.glob(File.join(BuckyBox::API.fixtures_path, "*.yml")).each do |file|
  cassette = File.basename(file, ".yml")
  puts "Loading cassette #{cassette}"
  VCR.insert_cassette cassette
end

Dir[Rails.root.join("spec/support/capybara/**/*.rb")].each { |f| require f }
