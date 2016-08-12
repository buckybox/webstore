# frozen_string_literal: true

require_relative "../../../app/models/checkout/home"

describe Home do
  let(:webstore) { double("webstore") } # rubocop:disable RSpec/VerifiedDoubles
  let(:logged_in_customer) { instance_double(Customer) }
  let(:home) { described_class.new(args) }
  let(:args) do
    {
      webstore: webstore,
      logged_in_customer: logged_in_customer,
      existing_customer: nil,
    }
  end

  describe "#customer" do
    it "returns a webstore customer" do
      customer = instance_double(Customer)
      customer_class = class_double(Customer, new: customer)
      expect(home.customer(customer_class)).to eq(customer)
    end
  end
end
