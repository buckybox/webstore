require "secure_headers"

::SecureHeaders::Configuration.configure do |config|
  # config.hsts = {:max_age => 20.years.to_i, :include_subdomains => true}
  # config.x_frame_options = 'DENY'
  # config.x_content_type_options = "nosniff"
  # config.x_xss_protection = {:value => 1, :mode => 'block'}
  # config.x_download_options = 'noopen'
  # config.x_permitted_cross_domain_policies = 'none'
  config.csp = {
  #   :default_src => "https: 'self'",
  #   :enforce => proc {|controller| controller.my_feature_flag_api.enabled? },
  #   :frame_src => "https: http:.twimg.com http://itunes.apple.com",
  #   :img_src => "https:",
  #   :connect_src => "wws:"
  #   :font_src => "'self' data:",
  #   :frame_src => "'self'",
  #   :img_src => "mycdn.com data:",
  #   :media_src => "utoob.com",
  #   :object_src => "'self'",
  #   :script_src => "'self'",
  #   :style_src => "'unsafe-inline'",
  #   :base_uri => "'self'",
  #   :child_src => "'self'",
  #   :form_action => "'self' github.com",
  #   :frame_ancestors => "'none'",
  #   :plugin_types => 'application/x-shockwave-flash',
  #   :block_all_mixed_content => '' # see [http://www.w3.org/TR/mixed-content/]()
    :report_uri => '//api.buckybox.com/csp-report'
  }
  # config.hpkp = {
  #   :max_age => 60.days.to_i,
  #   :include_subdomains => true,
  #   :report_uri => '//example.com/uri-directive',
  #   :pins => [
  #     {:sha256 => 'abc'},
  #     {:sha256 => '123'}
  #   ]
  # }
end
