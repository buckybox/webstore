require_relative '../../../app/models/webstore/cart'

describe Webstore::Cart do
  class Webstore::CartPersistence; end
  class Box; end
  class DeliveryService; end

  let(:persistence_class) { double('persistence_class') }
  let(:persistence)       { double('persistence') }
  let(:args)              { { distributor_id: 1, persistence_class: persistence_class } }
  let(:cart)              { Webstore::Cart.new(args) }

  describe '.find' do
    context 'when a cart is found' do
      it 'returns restored cart' do
        allow(cart).to receive(:id) { 1 }
        allow(persistence).to receive(:collected_data) { cart }
        allow(persistence_class).to receive(:find_by) { persistence }
        expect(Webstore::Cart.find(1, persistence_class).new?).to be false
      end
    end

    context 'when a cart is not found' do
      it 'returns nil' do
        allow(persistence_class).to receive(:find_by) { nil }
        expect(Webstore::Cart.find(1, persistence_class)).to be_nil
      end
    end
  end

  describe '#new?' do
    it 'is considered new if the cart does not have an true' do
      cart_without_id = Webstore::Cart.new(args)
      expect(cart_without_id.new?).to be true
    end

    it 'is not considered new if the cart has an true' do
      cart_without_id = Webstore::Cart.new(args.merge(id: 1))
      expect(cart_without_id.new?).not_to be true
    end
  end

  describe '#==' do
    context 'a cart is new' do
      let(:cart1) { Webstore::Cart.new(args) }

      it 'returns true if the carts are the same objects' do
        expect(cart1).to eq(cart1)
      end

      it 'returns false if the carts are diffent objects' do
        cart2 = Webstore::Cart.new(args)
        expect(cart1).not_to eq(cart2)
      end
    end

    context 'a cart has been saved' do
      let(:cart1) { Webstore::Cart.new(args.merge(id: 1)) }

      it 'returns true if the carts have the same id' do
        cart2 = Webstore::Cart.new(args.merge(id: 1))
        expect(cart1).to eq(cart2)
      end

      it 'returns false if the carts have a different id' do
        cart2 = Webstore::Cart.new(args.merge(id: 2))
        expect(cart1).not_to eq(cart2)
      end
    end
  end

  describe '#save' do

    context 'saving a new cart' do
      before do
        allow(persistence).to receive(:id) { nil }
        allow(cart).to receive(:find_or_create_persistence) { persistence }
      end

      context 'when save works' do
        it 'saves a cart and returns an true' do
          allow(persistence).to receive(:update_attributes) { true }
          expect(cart.save).to be true
        end
      end

      context 'when save fails' do
        it 'returns 0' do
          allow(persistence).to receive(:update_attributes) { false }
          expect(cart.save).to be false
        end
      end
    end

    context 'after finding an existing cart' do
      before do
        allow(persistence).to receive(:id) { 1 }
        allow(cart).to receive(:find_or_create_persistence) { persistence }
      end

      context 'when save works' do
        it 'saves a cart and returns an true' do
          allow(persistence).to receive(:update_attributes) { true }
          expect(cart.save).to be true
        end
      end

      context 'when save fails' do
        it 'returns 0' do
          allow(persistence).to receive(:update_attributes) { false }
          expect(cart.save).to be false
        end
      end
    end
  end

  describe '#add_product' do
    it 'returns true if the product is successfully added to the order' do
      allow(cart.order).to receive(:add_product) { true }
      expect(cart.add_product(product_id: 1)).to be true
    end
  end
end
