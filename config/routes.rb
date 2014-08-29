Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  scope ":webstore_id" do
    # get "/fruits", action: "fruits", controller: "store" # TODO: categories using box tags

    # NOTE: future URLs for reference
    # scope "/account", module: :account do
    #   get "/", action: "dashboard", as: "customer_dashboard"
    #   get "/sign_in", action: "sign_in", as: "customer_sign_in"
    # end

    get "/", to: "store#home", as: "webstore"
    get "/admin", to: redirect("/distributors/sign_in") # NOTE: temporary redirect
    match "/start_checkout/:product_id", to: "store#start_checkout", via: [:get, :post], as: "start_checkout" # FIXME: do we need POST?

    scope module: :customise_order do
      get  "/customise_order", action: "customise_order"
      post "/customise_order", action: "save_order_customisation"
    end

    scope module: :authentication do
      get  "/authentication", action: "authentication"
      post "/authentication", action: "save_authentication"
    end

    scope module: :delivery_options do
      get  "/delivery_options", action: "delivery_options"
      post "/delivery_options", action: "save_delivery_options"
    end

    scope module: :payment_options do
      get  "/payment_options", action: "payment_options"
      post "/payment_options", action: "save_payment_options"
    end

    scope module: :completed do
      get "/completed", action: "completed"
    end
  end
end

