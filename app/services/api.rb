# frozen_string_literal: true

class API
  class << self
    WEBSTORE_ID_FORMAT = /\A[a-z0-9\-_]+\Z/.freeze

    def webstore(id)
      raise BuckyBox::API::NotFoundError if id !~ WEBSTORE_ID_FORMAT

      webstore_id(id)
      api.webstore
    end

    def method_missing(method, *args)
      api.respond_to?(method) ? api.public_send(method, *args) : super
    end

    def respond_to_missing?(*args)
      api.respond_to?(*args)
    end

  private

    def webstore_id(id = nil)
      Thread.current[:webstore_id] = id unless id.nil?
      Thread.current[:webstore_id]
    end

    def api
      @api ||= {}
      @api[webstore_id] ||= BuckyBox::API.new(
        credentials.merge("Webstore-ID" => webstore_id),
      )
    end

    def credentials
      @credentials ||= begin
        key = Figaro.env.buckybox_api_key
        secret = Figaro.env.buckybox_api_secret

        key ||= "" if Rails.env.test?
        secret ||= "" if Rails.env.test?

        raise "You must set BUCKYBOX_API_KEY and BUCKYBOX_API_SECRET variables" if key.nil? || secret.nil?

        { "API-Key" => key, "API-Secret" => secret }
      end
    end
  end
end
