# frozen_string_literal: true

require_relative "../../../app/models/checkout/authentication"

describe Authentication do
  let(:cart)           { instance_double(Cart) }
  let(:args)           { { cart: cart } }
  let(:authentication) { described_class.new(args) }

  describe "#options" do
    it "returns an option for authorisation" do
      expected_options = [["I'm a new customer", "new"], ["I'm a returning customer", "returning"]]
      expect(authentication.options).to eq(expected_options)
    end
  end

  describe "#webstore_id" do
    it "returns the name of the web store associated with this cart" do
      allow(cart).to receive(:webstore_id) { "webstore-name" }
      expect(authentication.webstore_id).to eq("webstore-name")
    end
  end

  describe "#to_h" do
    it "returns a hash of the important form data" do
      authentication.email    = "test@example.com"
      authentication.password = "password"
      expect(authentication.to_h).to eq(email: "test@example.com")
    end
  end
end
