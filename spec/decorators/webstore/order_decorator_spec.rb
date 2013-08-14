require 'fast_spec_helper'
stub_constants %w(Extra)
require_relative '../../../app/decorators/webstore/order_decorator'
Draper::ViewContext.test_strategy :fast

describe Webstore::OrderDecorator do
  include Draper::ViewHelpers

  let(:money) { double('money', format: '$1.25') }
  let(:object) { double('object') }
  let(:order_decorator) { Webstore::OrderDecorator.new(object) }

  describe '#product_price' do
    it 'returns a formatted version of the product price' do
      object.stub(:product_price) { money }
      order_decorator.product_price.should { '$1.25' }
    end
  end

  describe '#extras_price' do
    it 'returns a formatted version of the extas price' do
      object.stub(:extras_price) { money }
      order_decorator.extras_price.should { '$1.25' }
    end
  end

  describe '#delivery_fee' do
    it 'returns a formatted version of the delivery fee' do
      object.stub(:delivery_fee) { money }
      order_decorator.delivery_fee.should { '$1.25' }
    end
  end

  describe '#bucky_fee' do
    it 'returns a formatted version of the bucky fee' do
      object.stub(:bucky_fee) { money }
      order_decorator.bucky_fee.should { '$1.25' }
    end
  end

  describe '#discount' do
    it 'returns a formatted version of the discount' do
      object.stub(:discount) { money }
      order_decorator.discount.should { '$1.25' }
    end
  end

  describe '#total' do
    it 'returns a formatted version of the total' do
      object.stub(:total) { money }
      order_decorator.total.should { '$1.25' }
    end
  end

  describe '#extras' do
    let(:extras) { [double('extra')] }
    let(:decorated_extras) { order_decorator.extras }

    before { object.stub(:extras) { extras } }

    it 'returns a list of extras' do
      decorated_extras.should eq(extras)
    end

    it 'returns a decorated list of extras' do
      decorated_extras.first.should be_decorated_with(ExtraDecorator)
    end
  end

  describe '#exclusions_string' do
    it 'returns a description of the exclusions' do
      order_decorator.exclusions_string.should { '' }
    end
  end

  describe '#substitutions_string' do
    it 'returns a description of the substitutions' do
      order_decorator.substitutions_string.should { '' }
    end
  end

  describe '#extras_description' do
    it 'returns a description of the extras' do
      order_decorator.extras_description.should { '' }
    end
  end
end
