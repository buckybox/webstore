Given /^I am on the webstore$/ do
  path = webstore_store_path(distributor_parameter_name: Distributor.last.parameter_name)
  visit path
end

When /^I select a customisable box to order$/ do
  find("#webstore-items").first(:button, "Order").click # first button found, e.g. first box
end

Then /^I should be asked to customise the box$/ do
  step "I should be viewing the customise_order step"
  step "I should not see a message"
end

Given /^I am asked to customise the box$/ do
  steps %Q{
    Given I am on the webstore
    When I select a customisable box to order
  }

  step "I should be asked to customise the box"
end

When /^I customise the box$/ do
  check "Customise my box"
  select2("Grapes", from: "webstore_customise_order_dislikes")
  # TODO test subs
  click_button "Next"
end

Then "I should be asked to log in or sign up" do
  step "I should be viewing the authentication step"
  step "I should not see a message"
end

When /^I fill in my email address$/ do
  fill_in :webstore_authentication_email, with: "starving.rabbit+#{SecureRandom.uuid}@example.net"
  click_button "Next"
end

Then /^I should be asked to select my delivery frequency$/ do
  step "I should be viewing the delivery_options step"
  step "I should not see a message"
end

Given "I am asked to select my delivery frequency" do
  steps %Q{
    Given I am asked to customise the box
    When I customise the box
  }

  if page.has_link? "Login" # we need to log in
    step "I fill in my email address"
  end
end

When /^I select a (.*) delivery frequency$/ do |frequency|
  select frequency, from: :webstore_delivery_options_frequency
  click_button "Next"
end

Then /^I should be asked for my delivery address$/ do
  step "I should be viewing the payment_options step"
  step "I should not see a message"
end

Given "I am asked for my delivery address" do
  steps %Q{
    Given I am asked to select my delivery frequency
    When I select a monthly delivery frequency
  }

  step "I should be asked for my delivery address"
end

When /^I (fill in|confirm) my delivery address$/ do |action|
  if action == "fill in"
    fill_in :webstore_payment_options_name, with: "Crazy Rabbit"
    fill_in :webstore_payment_options_address_1, with: "Rabbit Hole"
  end

  expect {
    click_button "Complete Order"
  }.to change{Order.count}.by(1)
end

When /^I select the payment option "(.*)"$/ do |option|
  within "#payment-options" do
    choose option
  end
end

Then /^My order should be placed$/ do
  step 'I should see a success message with "Your order has been placed"'
end

Then /^I should see the details of my order$/ do
  page.should have_content "Payment instructions",
    "Pay by Cash On Delivery",
    "Order summary",
    "Deliver to"
end

Given "I have just ordered a box" do
  steps %Q{
    Given I am asked for my delivery address
    When I select the payment option "Cash on delivery"
    And I fill in my delivery address
  }
end

Given /^I am viewing the (.*) step$/ do |step|
  visit webstore_step_path(step)

  step "I should be viewing the #{step} step"
end

Then /^I should be viewing the (.*) step$/ do |step|
  expected_path = webstore_step_path(step)
  current_path.should eq expected_path

  titles = {
    "payment_options" => "Address and Payment"
  }

  title = titles.fetch(step, step.titleize)

  page.should have_title "Bucky Box - Webstore - #{title}"
  step "I should not see an failure message"
end

def webstore_step_path step
  path_helper = "webstore_#{step}_path"
  public_send(path_helper, distributor_parameter_name: Distributor.last.parameter_name)
end

