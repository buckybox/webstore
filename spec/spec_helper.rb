# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "simplecov" if ENV["COVERAGE"]

require File.expand_path("../config/environment", __dir__)

require "rspec/rails"
RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.infer_spec_type_from_file_location!
  # config.disable_monkey_patching! # TODO
  config.warnings = true
end
