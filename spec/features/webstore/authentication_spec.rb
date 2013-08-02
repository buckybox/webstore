require_relative "../../support/webstore/webstore_helper"

describe "authenticate" do
  include Webstore::StoreHelpers
  include Webstore::CustomiseOrderHelpers
  include Webstore::AuthenticationHelpers

  before do
    get_to_authentication_step
  end

  context "as an existing customer" do
    before do
      @customer = Fabricate(:customer, password: "PASSWORD")
      fill_in "webstore_authentication_email", with: @customer.email
    end

    context "when 'new customer' is selected" do
      before do
        choose "I'm a new customer"
      end

      it "returns an error" do
        submit

        expect(page).to have_content("You must enter your password")
      end
    end

    context "when 'returning customer' is selected" do
      before do
        choose "I'm a returning customer"
      end

      context "with correct credentials" do
        before do
          fill_in "webstore_authentication_password", with: @customer.password
        end

        it "goes to the next step" do
          submit

          path = webstore_authentication_path(distributor_parameter_name: @distributor.parameter_name)
          expect(current_path).to_not eq(path)
        end
      end

      context "with incorrect credentials" do
        before do
          fill_in "webstore_authentication_password", with: @customer.password * 2
        end

        it "returns an error" do
          submit

          expect(page).to have_content("Your email and/or password is incorrect")
        end
      end
    end
  end

  def get_to_authentication_step
    make_a_webstore_with_products
    visit webstore_store_path(@distributor.parameter_name)
    click_button "Order"
  end

  def submit
    click_button "Next"
  end
end

