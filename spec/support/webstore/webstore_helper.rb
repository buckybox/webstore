require 'spec_helper'

RSpec.configure do |config|
  config.include Webstore::SetupWebstoreHelpers,  type: :feature
  config.extend Webstore::SetupWebstoreMacros,    type: :feature
end
