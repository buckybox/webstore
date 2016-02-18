# frozen_string_literal: true

module FactoryHelper
  def webstore
    @webstore ||= double(:webstore, id: 1)
  end

  def box
    return @box if @box

    extras = Array.new(2) { |i| double(:extra, id: i, webstore: webstore) }
    box = double(:customisable_box, id: 1, webstore: webstore, extras: extras)

    @box ||= box
  end

  def exclusion
    @exclusion ||= double(:line_item, id: 1, webstore: webstore)
  end

  def substitution
    @substitution ||= double(:line_item, id: 1, webstore: webstore)
  end

  def cart
    return @cart if @cart

    cart = Cart.new(
      webstore_id: webstore.id,
      customer: {
        cart: double("Cart"),
        existing_customer_id: nil,
      },
      order: {
        product_id: box.id,
        cart: double("Cart"),
        information: {
          dislikes: [
            exclusion.id,
          ],
          likes: [
            substitution.id,
          ],
          extras: {
            box.extras[0].id => 2,
            box.extras[1].id => 3,
          },
          email: "test@example.net",
          password: "",
          delivery_service_id: 1,
          start_date: "Fri, 02 Aug 2013",
          frequency: "weekly",
          days: { 2 => 1, 5 => 1 },
          extra_frequency: false,
          name: "Bob",
          phone_number: "007",
          phone_type: "mobile",
          address_1: "Street 1",
          address_2: "",
          suburb: "",
          city: "Southwell",
          postcode: "",
          delivery_note: "",
          payment_method: "bank_deposit",
          complete: true,
        },
      }
    )

    allow(cart.customer).to receive(:cart) { cart }
    allow(cart.order).to receive(:cart) { cart }

    @cart ||= cart
  end

  def args
    @args ||= { cart: cart, customer: cart.customer }
  end

  def information_hash
    @information_hash ||= cart.order.information
  end
end
