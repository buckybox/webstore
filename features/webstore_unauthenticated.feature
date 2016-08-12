@javascript
Feature: Unauthenticated customer places an order

Background:
  Given I am unauthenticated

Scenario: Order a box
  Given I am on the webstore
  When I select a customisable box to order
  Then I should be asked to customise the box
  When I customise the box
  Then I should be asked to log in or sign up
  When I fill in my email address
  Then I should be asked to select my delivery frequency
  When I select a monthly delivery frequency
  Then I should be asked for my delivery address
  When I fill in my delivery address
  And I select the payment option "Cash on Delivery"
  Then My order should be placed
  And I should see the details of my order
