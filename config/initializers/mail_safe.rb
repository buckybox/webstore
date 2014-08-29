if defined?(MailSafe::Config)
  MailSafe::Config.internal_address_definition = lambda { |address|
    address =~ /.*@buckybox\.com/i &&
    address != Figaro.env.support_email
  }

  MailSafe::Config.replacement_address = Figaro.env.mail_safe
end
