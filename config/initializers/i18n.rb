if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |exception, locale, key, options|
    raise "Missing translation for locale #{locale}: #{key}"
  end
end
