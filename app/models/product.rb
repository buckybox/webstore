require 'draper'

class Product
  include Draper::Decoratable

  attr_reader :box
  attr_reader :distributor

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

  delegate :name, to: :box

  delegate :description, to: :box

  delegate :price, to: :box
end
