require 'fast_spec_helper'
require_model 'product', sub_dir: 'webstore'

describe Webstore::Product do
  let(:distributor) { double('distributor') }
  let(:box)         { double('box') }
  let(:args)        { { distributor: distributor, box: box } }
  let(:product)     { Webstore::Product.new(args) }

  describe '#image' do
    it 'gives an image of the product' do
      box.stub(:webstore_image_url) { 'box.png' }
      product.image.should eq('box.png')
    end
  end

  describe '#name' do
    it 'gives the name of the product' do
      box.stub(:name) { 'fruit box' }
      product.name.should eq('fruit box')
    end
  end

  describe '#description' do
    it 'gives a description of the product' do
      box.stub(:description) { 'Fruit box' }
      product.description.should eq('Fruit box')
    end
  end

  describe '#price' do
    it 'gives the price of the product' do
      box.stub(:price) { 1.25 }
      product.price.should eq(1.25)
    end
  end
end
