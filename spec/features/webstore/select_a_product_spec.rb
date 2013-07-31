require_relative '../../support/webstore/webstore_helper'

describe 'select a product from the webstore' do
  include Webstore::StoreHelpers
  include Webstore::CustomiseOrderHelpers
  include Webstore::CustomerAuthorisationHelpers
  include Webstore::DeliveryOptionsHelpers

  context 'when the product can be customised' do
    context 'customer not logged in' do
      before do
        pending
        make_a_webstore_with_products
        visit webstore_store_path(@distributor.parameter_name)
        customisable_product(product)
        click_button 'Order'
      end

      it_behaves_like 'it is on the customise page'
    end

    context 'when the customer is logged in' do
      before do
        make_a_webstore_with_products
        sign_in_customer_to_webstore
        visit webstore_store_path(@distributor.parameter_name)
        customisable_product(product)
        click_button 'Order'
      end

      it_behaves_like 'it is on the customise page'
    end
  end

  context 'when the product can not be customised' do
    context 'customer not logged in' do
      before do
        make_a_webstore_with_products
        visit webstore_store_path(@distributor.parameter_name)
        noncustomisable_product(product)
        click_button 'Order'
      end

      it_behaves_like 'it is on the customer authorisation page'
    end

    context 'when the customer is logged in' do
      before do
        make_a_webstore_with_products
        sign_in_customer_to_webstore
        visit webstore_store_path(@distributor.parameter_name)
        noncustomisable_product(product)
        click_button 'Order'
      end

      it_behaves_like 'it is on the delivery options page'
    end
  end

  def sign_in_customer_to_webstore
    @customer = Fabricate(:customer, distributor: @distributor)
    simulate_customer_sign_in
  end

  def customisable_product(product)
    product.dislikes     = true
    product.extras_limit = -1
    product.save
  end

  def noncustomisable_product(product)
    product.dislikes     = false
    product.extras_limit = 0
    product.save
  end
end
