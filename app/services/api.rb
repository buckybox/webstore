class API
  class << self
    attr_accessor :webstore_id

    def webstore(id = nil)
      if id != webstore_id
        self.webstore_id = id
        @api = nil
      end

      method_missing(:webstore) # funny heh?
    end

    def method_missing(method, *args)
      api.public_send(method, *args)
    end

    private def api
      @api ||= begin
        raise "WTF" unless webstore_id

        BuckyBox::API.new(
          "API-Key" => Figaro.env.buckybox_api_key,
          "API-Secret" => Figaro.env.buckybox_api_secret,
          "Webstore-ID" => webstore_id,
        )
      end
    end
  end
end
