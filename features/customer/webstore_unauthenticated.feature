# NOTE: see also webstore_authenticated.feature

@javascript
Feature: Unauthenticated customer places an order
  In order to buy veggies from a distributor
  As an unauthenticated visitor
  I want to be able to order via the webstore

Background:
  Given A distributor is in the system
  And I am unauthenticated

Scenario: Select a box
  Given I am on the webstore
  When I select a customisable box to order
  Then I should be asked to customise the box

Scenario: Customise a box
  Given I am asked to customise the box
  When I customise the box
  Then I should be asked to log in or sign up

Scenario: Choose my delivery frequency
  Given I am asked to select my delivery frequency
  When I select a monthly delivery frequency
  Then I should be asked for my delivery address

Scenario: Order a box
  Given I am asked for my delivery address
  When I select the payment option "Cash on delivery"
  And I fill in my delivery address
  Then My order should be placed
  And I should see the details of my order

