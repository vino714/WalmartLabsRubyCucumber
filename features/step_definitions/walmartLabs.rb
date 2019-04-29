Given(/^I am on Walmart PDP page$/) do
  visit(GetUrl)
end

When(/^I click Add to Cart$/) do
  @product_title = on(ProductItem::PDPScreen).get_pdt_title
  @product_description = on(ProductItem::PDPScreen).get_pdt_desc
  @product_price = on(ProductItem::PDPScreen).get_pdt_price
  @selected_color = on(ProductItem::PDPScreen).select_color
  @quantity_added = on(ProductItem::PDPScreen).increase_quantity
  on(ProductItem::PDPScreen).click_atc
  on(ProductItem::PDPScreen).atc_modal_displayed?
  on(ProductItem::PDPScreen).verify_atc_title(@product_title)
end

Then(/^the product should be added into cart$/) do
  on(ProductItem::PDPScreen).atc_modal_displayed?
  (on(ProductItem::PDPScreen).get_cart_total).equal?@quantity_added
end

And(/^I verify the attributes selected in the Add to cart popup$/) do
  on(ProductItem::PDPScreen).verify_atc_title(@product_title)
  on(ProductItem::PDPScreen).verify_atc_color(@selected_color)
  on(ProductItem::PDPScreen).verify_atc_price(@product_price)
  ((on(ProductItem::PDPScreen).get_atc_subtotal).to_i).should == (@product_price.to_i * @quantity_added.to_i)
end

When(/^I change the quantity of the product in Add to Cart pop up$/) do
  @increased_qty = on(ProductItem::PDPScreen).increase_qty_atc
end

Then(/^price of the Subtotal should be updated accordingly$/) do
  on(ProductItem::PDPScreen).verify_atc_qty_price(@product_price, @increased_qty)
end

And(/^I navigate to reviews section$/) do
  on(ProductItem::PDPScreen).click_review_below_title
  on(ProductItem::PDPScreen).review_button?
end

When(/^I click on sorting as "([^"]*)"$/) do |arg|
  on(ProductItem::PDPScreen).select_review_sort_option(arg)
end

Then(/^the result should be sorted based on Ratings$/) do
  on(ProductItem::PDPScreen).verify_sort_star_low_to_high
end