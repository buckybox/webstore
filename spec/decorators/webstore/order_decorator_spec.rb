require 'fast_spec_helper'
stub_constants %w(Extra)
require_relative '../../../app/decorators/webstore/order_decorator'
Draper::ViewContext.test_strategy :fast

describe Webstore::OrderDecorator do
  include Draper::ViewHelpers

  let(:money) do
    money = double('money', with_currency: '$1.25')
    allow(money).to receive(:opposite) { money }
    money
  end

  let(:object) { double('object').as_null_object }
  let(:order_decorator) { Webstore::OrderDecorator.new(object) }

  describe '#product_price' do
    it 'returns a formatted version of the product price' do
      allow(object).to receive(:product_price) { money }
      expect(order_decorator.product_price).to eq '$1.25'
    end
  end

  describe '#extras_price' do
    it 'returns a formatted version of the extas price' do
      allow(object).to receive(:extras_price) { money }
      expect(order_decorator.extras_price).to eq '$1.25'
    end
  end

  describe '#discount' do
    it 'returns a formatted version of the discount' do
      allow(object).to receive(:discount) { money }
      expect(order_decorator.discount).to eq '$1.25'
    end
  end

  describe '#total' do
    it 'returns a formatted version of the total' do
      allow(object).to receive(:total) { money }
      expect(order_decorator.total).to eq '$1.25'
    end
  end
end
