# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "simplecov" if ENV["COVERAGE"]

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "capybara/rails"
require "capybara/poltergeist"
require "capybara-screenshot/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.default_driver = Capybara.javascript_driver = :poltergeist
Capybara.asset_host = "http://localhost:3000"

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  # config.disable_monkey_patching! # TODO
  config.warnings = true
  config.profile_examples = 10
  config.order = :random

  config.filter_run :focus
  config.filter_run_excluding :api unless ENV["TEST_API"]
  config.run_all_when_everything_filtered = true

  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  # config.use_transactional_fixtures = false

  # config.include AbstractController::Translation # `t` instead of `I18n.t` in tests
  # config.include Requests::JsonHelpers, type: :request

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
end
