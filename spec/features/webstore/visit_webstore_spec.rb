require_relative 'webstore_helper'

describe 'visit the webstore homepage' do
  let(:distributor_name)           { 'Local Veg' }
  let(:distributor_city)           { 'Wellington' }
  let(:distributor_about)          { 'Local farm.' }
  let(:distributor_details)        { 'Sells veg.' }
  let(:distributor_facebook_url)   { 'http://fb.com' }
  let(:product_name)               { 'Fruit Box' }
  let(:product_description)        { 'Fruit in a box.' }
  let(:product_price)              { 2.00 }
  let(:hidden_product_name)        { 'Veg Box' }
  let(:hidden_product_description) { 'Veg in a box.' }
  let(:hidden_product_price)       { 3.00 }
  let(:distributor) do
    Fabricate(:distributor,
      name:          distributor_name,
      city:          distributor_city,
      about:         distributor_about,
      details:       distributor_details,
      facebook_url:  distributor_facebook_url
    )
  end
  let(:product) do
    Fabricate(:box,
      distributor:  distributor,
      name:         product_name,
      description:  product_description,
      price:        product_price
    )
  end
  let(:hidden_product) do
    Fabricate(:box,
      hidden:       true,
      distributor:  distributor,
      name:         hidden_product_name,
      description:  hidden_product_description,
      price:        hidden_product_price
    )
  end

  before do
    @distributor = distributor
    setup_a_webstore(product)
    visit webstore_store_path(distributor.parameter_name)
  end

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
