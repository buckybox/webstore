require "secure_headers"

SecureHeaders::Configuration.configure do |config|
  config.x_frame_options = "DENY"
  config.x_xss_protection = { value: 1, mode: "block" }
  config.csp = {
    enforce: false,
    default_src: "'self'",
    img_src: "'self' https://my.buckybox.com",
    script_src: "'self' 'unsafe-inline'",
    form_action: "'self'",
    frame_ancestors: "https://mydeal-tahiti.com/",
    block_all_mixed_content: "",
    report_uri: "https://api.buckybox.com/v1/csp-report",
  }
  # config.hpkp = {
  # TODO: set up HPKP
  # }
end
