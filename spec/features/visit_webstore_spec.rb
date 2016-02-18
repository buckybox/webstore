# frozen_string_literal: true

describe "visit the webstore homepage", :js do
  include StoreHelpers

  before do
    make_a_webstore_with_products
    visit webstore_path(@webstore.id)
  end

  it "shows the webstore information" do
    expect(page).to have_content(webstore_name)
    expect(page).to have_content(webstore_city)
    expect(page).to have_content(webstore_sidebar_description)
    expect(page).to have_content("Find us on Facebook")
    expect(page).to have_content(webstore.phone)
  end

  describe "products" do
    it "shows the product that is not hidden" do
      expect(page).to have_content(product_name)
      expect(page).to have_content(product_description)
      expect(page).to have_content(product_price)
    end

    it "hides the product that is hidden" do
      expect(page).not_to have_content(hidden_product_name)
      expect(page).not_to have_content(hidden_product_description)
      expect(page).not_to have_content(hidden_product_price)
    end
  end

  context "logged in" do
    before do
      @customer = Fabricate(:customer, webstore: @webstore)
      simulate_customer_sign_in
    end

    it "logs in the customer automatically" do
      expect(page).to have_content("My Account (#{@customer.name})")
    end
  end
end
