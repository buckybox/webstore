# frozen_string_literal: true

require 'spec_helper'
require_relative 'setup_webstore_helpers'
require_relative 'setup_webstore_macros'

RSpec.configure do |config|
  config.include SetupWebstoreHelpers,  type: :feature
  config.extend SetupWebstoreMacros,    type: :feature
end
