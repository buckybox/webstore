# frozen_string_literal: true

module StoreHelpers
  def self.included(base)
    base.let(:webstore_id)                  { 'local-veg' }
    base.let(:webstore_name)                { 'Local Veg' }
    base.let(:webstore_city)                { 'Wellington' }
    base.let(:webstore_sidebar_description) { 'Local farm.' }
    base.let(:webstore_facebook_url)        { 'http://fb.com' }

    base.let(:webstore) do
      double(:webstore,
        id:                   webstore_id,
        name:                 webstore_name,
        city:                 webstore_city,
        sidebar_description:  webstore_sidebar_description,
        facebook_url:         webstore_facebook_url
      )
    end

    base.let(:product_name)        { 'Fruit Box' }
    base.let(:product_description) { 'Fruit in a box.' }
    base.let(:product_price)       { 2.00 }

    base.let(:product) do
      double(:box,
        webstore:     webstore,
        name:         product_name,
        description:  product_description,
        price:        product_price
      )
    end

    base.let(:hidden_product_name)        { 'Veg Box' }
    base.let(:hidden_product_description) { 'Veg in a box.' }
    base.let(:hidden_product_price)       { 3.00 }

    base.let(:hidden_product) do
      double(:box,
        hidden:       true,
        webstore:     webstore,
        name:         hidden_product_name,
        description:  hidden_product_description,
        price:        hidden_product_price
      )
    end
  end

  def make_a_webstore_with_products
    @webstore ||= webstore
  end
end
