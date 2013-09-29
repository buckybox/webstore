require "spec_helper"

describe Webstore::StoreController do
  describe "#store" do
    before do
      @distributor = Fabricate(:distributor_with_everything)
    end

    it "notifies that the cart has been reseted if present" do
      controller.stub(:current_cart) { double("cart") }

      get :store, distributor_parameter_name: @distributor.parameter_name

      expect(flash[:notice]).to_not be_nil
    end
  end
end

