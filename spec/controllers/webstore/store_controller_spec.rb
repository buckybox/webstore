require "spec_helper"

describe Webstore::StoreController do
  describe "#store" do
    before do
      @distributor = Fabricate(:distributor_with_everything)
    end

    it "redirects to the expected step if cart is present" do
      controller.stub(:current_cart) { double(expected_next_step: "/whatever") }

      get :store, distributor_parameter_name: @distributor.parameter_name

      expect(response).to redirect_to "/whatever"
    end
  end
end

