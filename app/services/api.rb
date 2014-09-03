class API
  class << self
    extend Forwardable
    def_delegators :api, :webstore, :boxes, :box, :customer, :delivery_services

    attr_accessor :webstore_id

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
