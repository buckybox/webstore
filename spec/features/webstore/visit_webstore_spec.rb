require_relative "../../support/webstore/webstore_helper"

describe "visit the webstore homepage" do
  include Webstore::StoreHelpers

  before do
    make_a_webstore_with_products
    visit webstore_store_path(@distributor.parameter_name)
  end

  it "shows the distributor information" do
    expect(page).to have_content(distributor_name)
    expect(page).to have_content(distributor_city)
    expect(page).to have_content(distributor_about)
    expect(page).to have_content(distributor_details)
    expect(page).to have_content("Find us on Facebook")
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
      @customer = Fabricate(:customer, distributor: @distributor)
      simulate_customer_sign_in
    end

    it "logs in the customer automatically" do
      expect(page).to have_content("My account (#{@customer.name})")
    end
  end
end
