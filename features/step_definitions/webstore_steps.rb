World(Select2Helper)

def step_path(step)
  path_helper = "#{step}_path"
  public_send(path_helper, webstore_id: "fantastic-vege-people")
end

Given /^I am authenticated$/ do
  step "I am on the webstore"
  step "I log in" if page.has_link?("Log in")
  expect(page).not_to have_link("Log in")
end

Given /^I am unauthenticated$/ do
  step "I am on the webstore"
  step "I log out" if page.has_link?("Log out")
  expect(page).to have_link("Log in")
end

When /^I log out$/ do
  click "Log out"
end

Given /^I log in$/ do
  step "I am viewing the login page"
  step "I fill in valid credentials"
end

Given /^I am viewing the login page$/ do
  visit step_path("customer_sign_in")
end

When /^I fill in valid credentials$/ do
  fill_in "email", with: "joe@buckybox.com"
  fill_in "password", with: "whatever"
  click_button "Log in"
  step "I am authenticated"
end

Given /^I am on the webstore$/ do
  visit step_path("webstore")
end

When /^I select a customisable box to order$/ do
  click_link("Order", match: :first)
end

Then /^I should be asked to customise the box$/ do
  step "I should be viewing the customise_order step"
  step "I should not see an error message"
end

When /^I customise the box$/ do
  check "Customise my product"
  select2("Cabbage", from: "customise_order_dislikes")
  # TODO: test subs
  click_button "Next"
end

Then "I should be asked to log in or sign up" do
  step "I should be viewing the authentication step"
  step "I should not see an error message"
end

When /^I fill in my email address$/ do
  fill_in :authentication_email, with: "joe@buckybox.com"
  click_button "Next"
end

Then /^I should be asked to select my delivery frequency$/ do
  step "I should be viewing the delivery_options step"
  step "I should not see an error message"
end

When /^I select a (.*) delivery frequency$/ do |frequency|
  select frequency, from: :delivery_options_frequency
  click_button "Next"
end

Then /^I should be asked for my delivery address$/ do
  step "I should be viewing the payment_options step"
  step "I should not see an error message"
end

When /^I (fill in|confirm) my delivery address$/ do |action|
  if action == "fill in"
    fill_in :payment_options_name, with: "Crazy Rabbit"
    fill_in :payment_options_address_1, with: "Rabbit Hole"
  end
end

When /^I select the payment option "(.*)"$/ do |option|
  within "#payment-options" do
    choose option
  end

  click_button "Complete Order"
end

Then /^My order should be placed$/ do
  expect(page).to have_content "Your order has been placed"
end

Then /^I should see the details of my order$/ do
  expect(page).to have_content "Account details"
end

Then /^I should see "(.*)"$/ do |content|
  expect(page).to have_content content
end

Then /^I should be viewing the (.*) step$/ do |step|
  expected_path = step_path(step)
  expect(current_path).to eq expected_path

  expect(page.title).to start_with "Bucky Box - "

  step "I should not see an error message"
end

Then /^I should not see an error message$/ do
  expect(page).not_to have_content "Oops"
end
