# frozen_string_literal: true

require_relative '../../app/models/product'

describe Product do
  let(:webstore)    { double('webstore') }
  let(:box)         { double('box') }
  let(:args)        { { webstore: webstore, box: box } }
  let(:product)     { Product.new(args) }

  describe '#image' do
    it 'gives an image of the product' do
      allow(box).to receive(:webstore_image_url) { 'box.png' }
      expect(product.image).to eq('box.png')
    end
  end

  describe '#name' do
    it 'gives the name of the product' do
      allow(box).to receive(:name) { 'fruit box' }
      expect(product.name).to eq('fruit box')
    end
  end

  describe '#description' do
    it 'gives a description of the product' do
      allow(box).to receive(:description) { 'Fruit box' }
      expect(product.description).to eq('Fruit box')
    end
  end

  describe '#price' do
    it 'gives the price of the product' do
      allow(box).to receive(:price) { 1.25 }
      expect(product.price).to eq(1.25)
    end
  end
end
