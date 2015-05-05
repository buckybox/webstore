class API
  class << self
    attr_reader :webstore_id

    def webstore(id = nil)
      if id != webstore_id
        @webstore_id = id
        @api = nil
      end

      method_missing(:webstore) # funny heh?
    end

    def method_missing(method, *args)
      api.public_send(method, *args)
    end

    def respond_to_missing?(*args)
      api.respond_to?(*args)
    end

    private def api
      @api ||= begin
        params = {
          "API-Key" => Figaro.env.buckybox_api_key,
          "API-Secret" => Figaro.env.buckybox_api_secret,
        }

        params.merge!("Webstore-ID" => webstore_id) if webstore_id

        BuckyBox::API.new(params)
      end
    end
  end
end
