require 'draper'
require_relative '../webstore'

class Webstore::Product
  include Draper::Decoratable

  attr_reader :box
  attr_reader :distributor

  def initialize(args = {})
    @distributor = args[:distributor]
    @box         = args[:box]
  end

  def self.build_distributors_products(distributor)
    boxes = distributor.boxes.not_hidden
    build_products(boxes)
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

private

  def self.build_products(boxes)
    boxes.map { |box| new(distributor: box.distributor, box: box) }
  end
end
