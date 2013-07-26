require_relative '../../support/webstore/webstore_helper'

describe 'visit the webstore homepage' do
  include Webstore::StoreHelpers

  before { make_and_visit_a_webstore_with_products }

  it 'shows the distributor information' do
    expect(page).to have_content(distributor_name)
    expect(page).to have_content(distributor_city)
    expect(page).to have_content(distributor_about)
    expect(page).to have_content(distributor_details)
    expect(page).to have_content('Find us on Facebook')
  end

  context 'products' do
    it 'shows the product that is not hidden' do
      expect(page).to have_content(product_name)
      expect(page).to have_content(product_description)
      expect(page).to have_content(product_price)
    end

    it 'hides the product that is hidden' do
      expect(page).not_to have_content(hidden_product_name)
      expect(page).not_to have_content(hidden_product_description)
      expect(page).not_to have_content(hidden_product_price)
    end
  end
end
