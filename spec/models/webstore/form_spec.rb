require_relative '../../../app/models/webstore/form'

describe Webstore::Form do
  let(:form) { Webstore::Form.new }

  describe '#save' do
    let(:cart) { double('cart', add_order_information: true) }

    before { form.stub(:cart) { cart } }

    context 'successfully' do
      it 'returns true' do
        cart.stub(:save) { true }
        form.save.should be_true
      end
    end

    context 'unsuccessfully' do
      it 'returns false' do
        cart.stub(:save) { false }
        form.save.should be_false
      end
    end
  end

  describe '#persisted?' do
    it 'is false' do
      form.persisted?.should be_false
    end
  end
end
