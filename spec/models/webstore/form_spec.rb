require_relative '../../../app/models/webstore/form'

describe Webstore::Form do
  let(:form) { Webstore::Form.new }

  describe '#save' do
    let(:cart) { double('cart', add_order_information: true) }

    before { allow(form).to receive(:cart) { cart } }

    context 'successfully' do
      it 'returns true' do
        allow(cart).to receive(:save) { true }
        expect(form.save).to be true
      end
    end

    context 'unsuccessfully' do
      it 'returns false' do
        allow(cart).to receive(:save) { false }
        expect(form.save).to be false
      end
    end
  end

  describe '#persisted?' do
    it 'is false' do
      expect(form.persisted?).to be false
    end
  end
end
