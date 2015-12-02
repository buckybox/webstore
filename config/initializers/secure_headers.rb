require "secure_headers"

SecureHeaders::Configuration.configure do |config|
  config.x_frame_options = false
  config.x_xss_protection = { value: 1, mode: "block" }
  config.csp = {
    enforce: true,
    default_src: "'none'",
    img_src: "'self' my.buckybox.com *.google-analytics.com *.pingdom.net notify.bugsnag.com *.tile.openstreetmap.org",
    script_src: "'self' 'unsafe-inline' *.google-analytics.com *.pingdom.net js-agent.newrelic.com bam.nr-data.net https://d2wy8f7a9ursnm.cloudfront.net/bugsnag-2.min.js",
    style_src: "'self' 'unsafe-inline'",
    form_action: "'self' www.paypal.com",
    connect_src: "'self' api.buckybox.com freegeoip.net *.google-analytics.com",
    block_all_mixed_content: "",
    report_uri: "https://api.buckybox.com/v1/csp-report",
  }
  # config.hpkp = {
  # TODO: set up HPKP
  # }
end
