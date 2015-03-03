require 'draper'

class Product
  include Draper::Decoratable

  attr_reader :box
  attr_reader :distributor

  delegate :name, to: :box
  delegate :description, to: :box
  delegate :price, to: :box

  def initialize(args = {})
    @distributor = args[:distributor]
    @box         = args[:box]
  end

  def self.build_webstore_products
    API.boxes
  end

  def image
    box.webstore_image_url
  end
end
