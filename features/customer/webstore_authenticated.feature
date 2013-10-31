# NOTE: see also webstore_unauthenticated.feature

@javascript
Feature: Authenticated customer places an order
  In order to buy veggies from a distributor
  As an authenticated visitor
  I want to be able to order via the webstore

Background:
  Given I am a customer

Scenario: Select a box
  Given I am on the webstore
  When I select a customisable box to order
  Then I should be asked to customise the box

Scenario: Customise a box
  Given I am asked to customise the box
  When I customise the box
  Then I should be asked to select my delivery frequency

Scenario: Choose my delivery frequency
  Given I am asked to select my delivery frequency
  When I select a monthly delivery frequency
  Then I should be asked for my delivery address

Scenario: Order a box
  Given I am asked for my delivery address
  When I select the payment option "Cash on Delivery"
  And I confirm my delivery address
  Then My order should be placed
  And I should see the details of my order


