module Webstore::StoreHelpers
  def self.included(base)
    base.let(:distributor_name)         { 'Local Veg' }
    base.let(:distributor_city)         { 'Wellington' }
    base.let(:distributor_about)        { 'Local farm.' }
    base.let(:distributor_details)      { 'Sells veg.' }
    base.let(:distributor_facebook_url) { 'http://fb.com' }

    base.let(:distributor) do
      Fabricate(:distributor,
        name:          distributor_name,
        city:          distributor_city,
        about:         distributor_about,
        details:       distributor_details,
        facebook_url:  distributor_facebook_url
      )
    end

    base.let(:product_name)        { 'Fruit Box' }
    base.let(:product_description) { 'Fruit in a box.' }
    base.let(:product_price)       { 2.00 }

    base.let(:product) do
      Fabricate(:box,
        distributor:  distributor,
        name:         product_name,
        description:  product_description,
        price:        product_price
      )
    end

    base.let(:hidden_product_name)        { 'Veg Box' }
    base.let(:hidden_product_description) { 'Veg in a box.' }
    base.let(:hidden_product_price)       { 3.00 }

    base.let(:hidden_product) do
      Fabricate(:box,
        hidden:       true,
        distributor:  distributor,
        name:         hidden_product_name,
        description:  hidden_product_description,
        price:        hidden_product_price
      )
    end
  end

  def make_a_webstore_with_products
    @distributor = distributor
    setup_a_webstore(product) # Send at least one product so it doesn't make it's own
  end
end
