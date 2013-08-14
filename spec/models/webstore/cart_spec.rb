require_relative '../../../app/models/webstore/cart'

describe Webstore::Cart do
  class Webstore::CartPersistence; end
  class Box; end
  class Route; end

  let(:persistence_class) { double('persistence_class') }
  let(:persistence)       { double('persistence') }
  let(:args)              { { distributor_id: 1, persistence_class: persistence_class } }
  let(:cart)              { Webstore::Cart.new(args) }

  describe '.find' do
    context 'when a cart is found' do
      it 'returns restored cart' do
        cart.stub(:id) { 1 }
        persistence.stub(:collected_data) { cart }
        persistence_class.stub(:find_by) { persistence }
        Webstore::Cart.find(1, persistence_class).new?.should be_false
      end
    end

    context 'when a cart is not found' do
      it 'returns nil' do
        persistence_class.stub(:find_by) { nil }
        Webstore::Cart.find(1, persistence_class).should be_nil
      end
    end
  end

  describe '#new?' do
    it 'is considered new if the cart does not have an true' do
      cart_without_id = Webstore::Cart.new(args)
      cart_without_id.new?.should be_true
    end

    it 'is not considered new if the cart has an true' do
      cart_without_id = Webstore::Cart.new(args.merge(id: 1))
      cart_without_id.new?.should_not be_true
    end
  end

  describe '#==' do
    context 'a cart is new' do
      let(:cart1) { Webstore::Cart.new(args) }

      it 'returns true if the carts are the same objects' do
        cart1.should eq(cart1)
      end

      it 'returns false if the carts are diffent objects' do
        cart2 = Webstore::Cart.new(args)
        cart1.should_not eq(cart2)
      end
    end

    context 'a cart has been saved' do
      let(:cart1) { Webstore::Cart.new(args.merge(id: 1)) }

      it 'returns true if the carts have the same id' do
        cart2 = Webstore::Cart.new(args.merge(id: 1))
        cart1.should eq(cart2)
      end

      it 'returns false if the carts have a different id' do
        cart2 = Webstore::Cart.new(args.merge(id: 2))
        cart1.should_not eq(cart2)
      end
    end
  end

  describe '#save' do

    context 'saving a new cart' do
      before do
        persistence.stub(:id) { nil }
        cart.stub(:find_or_create_persistence) { persistence }
      end

      context 'when save works' do
        it 'saves a cart and returns an true' do
          persistence.stub(:update_attributes) { true }
          cart.save.should be_true
        end
      end

      context 'when save fails' do
        it 'returns 0' do
          persistence.stub(:update_attributes) { false }
          cart.save.should be_false
        end
      end
    end

    context 'after finding an existing cart' do
      before do
        persistence.stub(:id) { 1 }
        cart.stub(:find_or_create_persistence) { persistence }
      end

      context 'when save works' do
        it 'saves a cart and returns an true' do
          persistence.stub(:update_attributes) { true }
          cart.save.should be_true
        end
      end

      context 'when save fails' do
        it 'returns 0' do
          persistence.stub(:update_attributes) { false }
          cart.save.should be_false
        end
      end
    end
  end

  describe '#add_product' do
    it 'returns true if the product is successfully added to the order' do
      cart.order.stub(:add_product) { true }
      cart.add_product(product_id: 1).should be_true
    end
  end
end
