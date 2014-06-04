require_relative '../../../app/models/webstore/customise_order'

describe Webstore::CustomiseOrder do
  let(:product)         { double('product') }
  let(:cart)            { double('cart', product: product) }
  let(:args)            { { cart: cart } }
  let(:customise_order) { Webstore::CustomiseOrder.new(args) }

  describe '#stock_list' do
    it 'returns a list of stock items' do
      stock_list = [double('stock_item')]
      cart.stub(:stock_list) { stock_list }
      customise_order.stock_list.should eq(stock_list)
    end
  end

  describe '#extras_list' do
    it 'returns a list of extras items for a cart' do
      extras_list = [double('extra')]
      cart.stub(:extras_list) { extras_list }
      customise_order.extras_list.should eq(extras_list)
    end
  end

  describe '#exclusions?' do
    it 'returns true if a product allows exclusions' do
      product.stub(:dislikes?) { true }
      customise_order.exclusions?.should be true
    end

    it 'returns true if a product allows exclusions' do
      product.stub(:dislikes?) { false }
      customise_order.exclusions?.should be false
    end
  end

  describe '#substitutions?' do
    it 'returns true if a product allows substitutions' do
      product.stub(:likes?) { true }
      customise_order.substitutions?.should be true
    end

    it 'returns false if a product allows substitutions' do
      product.stub(:likes?) { false }
      customise_order.substitutions?.should be false
    end
  end

  describe '#extras_allowed?' do
    it 'returns true if a product allows extras' do
      product.stub(:extras_allowed?) { true }
      customise_order.extras_allowed?.should be true
    end

    it 'returns false if a product allows extras' do
      product.stub(:extras_allowed?) { false }
      customise_order.extras_allowed?.should be false
    end
  end

  describe '#extras_unlimited?' do
    it 'returns true if a product allows unlimited extras' do
      product.stub(:extras_unlimited?) { true }
      customise_order.extras_unlimited?.should be true
    end

    it 'returns false if a product allows unlimited extras' do
      product.stub(:extras_unlimited?) { false }
      customise_order.extras_unlimited?.should be false
    end
  end

  describe '#exclusions_limit' do
    it 'returns the exclusions limit' do
      product.stub(:exclusions_limit) { 5 }
      customise_order.exclusions_limit.should eq(5)
    end
  end

  describe '#substitutions_limit' do
    it 'returns the substitution limit' do
      product.stub(:substitutions_limit) { 5 }
      customise_order.substitutions_limit.should eq(5)
    end
  end

  describe '#extras_limit' do
    it 'returns the extras limit' do
      product.stub(:extras_limit) { 5 }
      customise_order.extras_limit.should eq(5)
    end
  end

  describe '#to_h' do
    it 'returns a hash of the important form data' do
      customise_order.dislikes = [1]
      customise_order.likes    = [1]
      customise_order.extras   = { 1 => 1 }
      customise_order.to_h.should eq({ dislikes: [1], likes: [1], extras: { 1 => 1 } })
    end
  end
end
