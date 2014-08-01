require_relative '../../../app/decorators/webstore/product_decorator'
Draper::ViewContext.test_strategy :fast

describe Webstore::ProductDecorator do
  include Draper::ViewHelpers

  let(:box)               { double('box') }
  let(:object)            { double('object', box: box, distributor: double.as_null_object) }
  let(:product_decorator) { Webstore::ProductDecorator.new(object) }

  describe '#price' do
    it 'returns a formatted version of the product price' do
      money = double('money', with_currency: '$1.25')
      allow(object).to receive(:price) { money }
      expect(product_decorator.price).to eq '$1.25'
    end
  end
end
