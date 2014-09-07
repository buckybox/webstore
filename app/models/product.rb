require 'draper'

class Product
  include Draper::Decoratable

  attr_reader :box
  attr_reader :distributor

  def initialize(args = {})
    @distributor = args[:distributor]
    @box         = args[:box]
  end

  def self.build_webstore_products(webstore)
    API.boxes
  end

  def image
    box.webstore_image_url
  end

  def name
    box.name
  end

  def description
    box.description
  end

  def price
    box.price
  end
end
