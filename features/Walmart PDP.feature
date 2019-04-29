Feature: Demo for PDP page

  Scenario: Add product to Cart
    Given I am on Walmart PDP page
    When I click Add to Cart
    Then the product should be added into cart
    And I verify the attributes selected in the Add to cart popup

  Scenario: verify the Add to cart popup updates the quantity and Price
    Given I am on Walmart PDP page
    When I click Add to Cart
    Then the product should be added into cart
    When I change the quantity of the product in Add to Cart pop up
    Then price of the Subtotal should be updated accordingly

   Scenario: Verify the reviews are sorted by lowest to Highest
     Given I am on Walmart PDP page
     And I navigate to reviews section
     When I click on sorting as "Lowest to Highest Rating"
     Then the result should be sorted based on Ratings