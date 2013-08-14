module Webstore::FactoryHelper
  def distributor
    @distributor ||= Fabricate(:distributor)
  end

  def box
    @box ||= Fabricate(:customisable_box, distributor: distributor)
  end

  def exclusion
    @exclusion ||= Fabricate(:line_item, distributor: distributor)
  end

  def substitution
    @substitution ||= Fabricate(:line_item, distributor: distributor)
  end

  def cart
    return @cart if @cart

    cart = Webstore::Cart.new(
      distributor_id: distributor.id,
      customer: {
        cart: double("Cart"),
        existing_customer_id: nil,
      },
      order: {
        product_id: box.id,
        cart: double("Cart"),
        information: {
          :dislikes=>[
            exclusion.id
          ],
          :likes=>[
            substitution.id
          ],
          :extras=> {
            box.extras[0].id => 2,
            box.extras[1].id => 3,
          },
          email: "test@example.net",
          password: "",
          route_id: 1,
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
          complete: true
        }
      }
    )

    cart.customer.stub(:cart) { cart }
    cart.order.stub(:cart) { cart }

    @cart ||= cart
  end

  def args
    @args ||= { cart: cart, customer: cart.customer }
  end

  def information_hash
    @information_hash ||= cart.order.information
  end
end

