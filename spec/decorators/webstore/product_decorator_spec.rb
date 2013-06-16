require_relative '../../../app/decorators/webstore/product_decorator'
Draper::ViewContext.test_strategy :fast

describe Webstore::ProductDecorator do
  include Draper::ViewHelpers

  let(:box)               { double('box') }
  let(:object)            { double('object', box: box) }
  let(:product_decorator) { Webstore::ProductDecorator.new(object) }

  describe '#price' do
    it 'returns a formatted version of the product price' do
      money = double('money', format: '$1.25')
      object.stub(:price) { money }
      product_decorator.price.should { '$1.25' }
    end
  end

  describe '#order_link' do
    it 'returns the URL path to start an order' do
      product_decorator.stub(:distributor_parameter_name)
      helpers.stub(webstore_start_order_path: '/path')
      product_decorator.order_link.should { '/path' }
    end
  end
end
