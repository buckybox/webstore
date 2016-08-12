@javascript
Feature: Authenticated customer places an order

Background:
  Given I am authenticated

Scenario Outline: Order a box
  Given I am on the webstore
  When I select a customisable box to order
  Then I should be asked to customise the box
  When I customise the box
  Then I should be asked to select my delivery frequency
  When I select a monthly delivery frequency
  Then I should be asked for my delivery address
  When I confirm my delivery address
  And I select the payment option "<method>"
  Then My order should be placed
  And I should see the details of my order
  And I should see "Pay by <method>"

  Examples:
    | method           |
    | Cash on Delivery |
    | Bank Deposit     |
    | PayPal           |
