if defined?(Bugsnag) && Figaro.env.bugsnag_api_key.present?
  Bugsnag.configure do |config|
    config.api_key = Figaro.env.bugsnag_api_key
    config.use_ssl = true
    config.notify_release_stages = %w(production staging)
  end
end
