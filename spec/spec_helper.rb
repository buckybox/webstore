ENV["RAILS_ENV"] ||= "test"

require "simplecov" if ENV["COVERAGE"]

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

require "capybara/rspec"
require "capybara/rails"
require "capybara/poltergeist"

Capybara.default_driver = Capybara.javascript_driver = :poltergeist
Capybara.asset_host = "http://buckybox.dev:3000"

require "capybara-screenshot/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  # config.infer_spec_type_from_file_location!
  config.order = "random"
  config.mock_with :rspec
  # config.use_transactional_fixtures = false
  # config.infer_base_class_for_anonymous_controllers = false
  config.filter_run_excluding :js, :slow unless ENV["CI"]

  # config.include Delorean
  # config.include AbstractController::Translation # `t` instead of `I18n.t` in tests
  # config.include Devise::TestHelpers,        type: :controller

  # # FIXME: Changed to all use @vars as this is majority convention.
  # # Want to change this to passed in vars to avoid side effects when
  # # it make sense to do so, in it's own branch on an eve or weekend.
  # config.include Devise::ControllerHelpers,  type: :controller
  # config.include Devise::RequestHelpers,     type: :request
  # config.include Devise::FeatureHelpers,     type: :feature

  # config.extend Devise::ControllerMacros,  type: :controller
  # config.extend Devise::RequestMacros,     type: :request
  # config.extend Devise::FeatureMacros,     type: :feature

  # config.include Requests::JsonHelpers, type: :request
end
