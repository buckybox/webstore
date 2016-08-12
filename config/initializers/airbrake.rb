# frozen_string_literal: true

if defined?(Airbrake) && Figaro.env.airbrake_host.present? && Figaro.env.airbrake_api_key.present?
  # :nocov:
  Airbrake.configure do |config|
    config.host    = Figaro.env.airbrake_host
    config.api_key = Figaro.env.airbrake_api_key
  end
  # :nocov:
end
