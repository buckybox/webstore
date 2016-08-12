# frozen_string_literal: true

require_relative "../../app/models/form"

describe Form do
  let(:form) { described_class.new }

  describe "#save" do
    let(:cart) { instance_double(Cart, add_order_information: true) }

    before { allow(form).to receive(:cart) { cart } }

    context "successfully" do
      it "returns true" do
        allow(cart).to receive(:save) { true }
        expect(form.save).to be true
      end
    end

    context "unsuccessfully" do
      it "returns false" do
        allow(cart).to receive(:save) { false }
        expect(form.save).to be false
      end
    end
  end

  describe "#persisted?" do
    it "is false" do
      expect(form.persisted?).to be false
    end
  end
end
