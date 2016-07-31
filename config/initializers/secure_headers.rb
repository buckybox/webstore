# frozen_string_literal: true
# rubocop:disable Lint/PercentStringArray

require "secure_headers"

SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.csp = {
    default_src: %w('none'),
    img_src: %w('self' my.buckybox.com *.google-analytics.com *.pingdom.net notify.bugsnag.com *.tile.openstreetmap.org),
    script_src: %w('self' 'unsafe-inline' *.google-analytics.com *.pingdom.net js-agent.newrelic.com bam.nr-data.net https://d2wy8f7a9ursnm.cloudfront.net/bugsnag-2.min.js),
    style_src: %w('self' 'unsafe-inline'),
    form_action: %w('self' www.paypal.com),
    connect_src: %w('self' api.buckybox.com *.google-analytics.com),
    report_uri: %w(https://api.buckybox.com/v1/csp-report),
  }
  # config.hpkp = {
  # TODO: set up HPKP
  # }
end
