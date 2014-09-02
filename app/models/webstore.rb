class Webstore
  def boxes
    Api.boxes
  end

  def self.fetch
    webstore = Api.webstore

    # webstore.instance_eval do
    #   def method_missing(method, *args)
    #     key?(method) ? self[method] : raise(NoMethodError, method)
    #   end
    # end

    webstore
  end
end
