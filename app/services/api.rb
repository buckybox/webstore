# frozen_string_literal: true

class API
  class << self
    WEBSTORE_ID_FORMAT = /\A[a-z0-9\-_]+\Z/

    attr_reader :webstore_id

    def webstore(id = nil)
      raise BuckyBox::API::NotFoundError if id !~ WEBSTORE_ID_FORMAT

      if id != webstore_id
        @webstore_id = id
        @api = nil
      end

      method_missing(:webstore) # funny heh?
    end

    def method_missing(method, *args)
      if api.respond_to?(method)
        api.public_send(method, *args)
      else
        super
      end
    end

    def respond_to_missing?(*args)
      api.respond_to?(*args)
    end

  private

    def api
      @api ||= BuckyBox::API.new(credentials)
    end

    def credentials
      key = Figaro.env.buckybox_api_key
      secret = Figaro.env.buckybox_api_secret

      key ||= "" if Rails.env.test?
      secret ||= "" if Rails.env.test?

      if key.nil? || secret.nil?
        raise "You must set BUCKYBOX_API_KEY and BUCKYBOX_API_SECRET variables"
      end

      { "API-Key" => key, "API-Secret" => secret, "Webstore-ID" => webstore_id }
    end
  end
end
