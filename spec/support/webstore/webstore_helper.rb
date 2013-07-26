require 'spec_helper'
require_relative 'setup_webstore_helpers'
require_relative 'setup_webstore_macros'

RSpec.configure do |config|
  config.include Webstore::SetupWebstoreHelpers,  type: :feature
  config.extend Webstore::SetupWebstoreMacros,    type: :feature
end
