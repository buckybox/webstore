class API
  class << self
    extend Forwardable
    def_delegators :api, :boxes, :box, :customer, :delivery_services, :current_customer, :authenticate_customer

    attr_accessor :webstore_id

    def webstore(id = nil)
      if id != webstore_id
        self.webstore_id = id
        @api = nil
      end

      api.webstore
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
