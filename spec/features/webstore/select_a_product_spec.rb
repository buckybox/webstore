require_relative '../../support/webstore/webstore_helper'

describe 'select a product from the webstore' do
  include Webstore::StoreHelpers
  include Webstore::CustomiseOrderHelpers
  include Webstore::CustomerAuthorisationHelpers
  include Webstore::DeliveryOptionsHelpers

  before { make_and_visit_a_webstore_with_products }

  context 'customer not logged in' do
    context 'when the product can be customised' do
      it_behaves_like 'it is on the customise page'
    end

    context 'when the product can not be customised' do
      it_behaves_like 'it is on the customer authorisation page'
    end
  end

  context 'when the customer is logged in' do
    context 'when the product can be customised' do
      it_behaves_like 'it is on the customise page'
    end

    context 'when the product can not be customised' do
      it_behaves_like 'it is on the delivery options page'
    end
  end
end
