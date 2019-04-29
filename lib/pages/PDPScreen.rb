module ProductItem
  class PDPScreen
    include PageObject

    #page_url ("https://www.walmart.ca/en/ip/hometrends-tuscany-4-piece-conversation-set-scarlet-red/6000197823909")

    link :page_logo, :id => 'logo-link-desktop'
    text_field :search_field, :id => 'global-search'
    button :my_acct_lnk, :id => 'account-menu-btn'
    links :breadcrumb_lnk, :css => 'nav > ol > li > a'
    h1 :pdp_title, :css => '[data-automation="product-title"]'
    p :pdp_description, :css => '[data-automation="short-description"]'
    button :title_review_count, :css => '[data-automation="review-link"]'
    span :item_price, :css => '[data-automation="buybox-price"]'
    elements :pdt_colors, :css => 'div[role="listbox"] button'
    button :decrease_qty, :css => '[data-automation="decrease-qty"]'
    button :increase_qty, :css => '[data-automation="increase-qty"]'
    text_field :selected_qty, :css => 'span[data-automation="quantity"] > input'
    button :add_to_cart_btn, :css => '[data-automation="cta-button"]'
    button :find_in_store_btn, :css => '[data-automation="find-in-store"]'
    div :add_to_cart_popup, :id => 'modal-root'
    div :atc_title, :css => '[data-automation="atcmodal-title"]'
    span :atc_color, :css => '#atcmodal-activeVariants > span'
    span :atc_price, :css => '[data-automation="atcmodal-price"]'
    button :atc_decrease_qty, :css => '#modal-root [data-automation="decrease-qty"]'
    button :atc_increase_qty, :css => '#modal-root [data-automation="increase-qty"]'
    text_field :atc_selected_qty, :css => '#modal-root span[data-automation="quantity"] > input'
    div :atc_qty_spinner, :css => "#modal-root div[role='button'] div"
    span :atc_subtotal, :css => '[data-automation="atcmodal-subtotal"] > span > span'
    div :atc_count, :css => '[data-automation="atcmodal-cart-count"]'
    button :atc_checkout, :css => '[data-automation="checkout"]'
    button :atc_continue_shopping, :css => '[data-automation="checkout"]'
    div :select_sort_btn, :class => 'bv-dropdown-target'
    span :cart_qty, :css => '#nav-cart >span'
    link :atc_suggestions_item_one, :css => '#modal-root .react-swipe-container div a'
    button :write_review, :css => '.bv-write-review-container button'
    unordered_list :sort_option, :css => '[role="menu"]'
    button :sort_button, :css => '#ratings-section .bv-control-bar .bv-dropdown-target button'
    span :reviews_displayed, :css => '#ratings-section .bv-control-bar  .bv-content-pagination-pages-current'
    spans :displayed_star_reviews, :css => '.bv-content-list-reviews>li .bv-rating-stars-container .bv-rating'
    span :load_more_btn, :css => '.bv-content-pagination-container .bv-content-btn-pages-load-more-text'
    expected_element :page_logo

    def initialize_page
      has_expected_element?
    end

    # Select area from Home Screen
    def select_color()
      c = pdt_colors_elements.sample
      selected_color = c.attribute('aria-label')
      c.click
      selected_color
    end

    def get_pdt_title
      pdp_title
    end

    def get_pdt_desc
      pdp_description
    end

    def get_pdt_price
      item_price.gsub("$", "")
    end

    def increase_quantity
      increase_qty_element.click
      Log.instance.debug("Increased Quantity")
      selected_qty
    end

    def decrease_quantity
      decrease_qty_element.click if decrease_qty_element.enabled?
      Log.instance.debug("Decreased Quantity")
      selected_qty
    end

    def total_quantity_pdp
      selected_qty
    end

    def click_atc
      return false if !(add_to_cart_btn_element.enabled?)
      add_to_cart_btn_element.click
      Log.instance.debug("Clicked Add to Cart")
    end

    def click_fis
      return false if !(find_in_store_btn_element.enabled?)
      find_in_store_btn_element.click
      Log.instance.debug("Clicked Find in Store button")
    end

    def get_cart_total
      cart_qty
    end

    def atc_modal_displayed?
      add_to_cart_popup_element.present?
    end

    def verify_atc_title(pge_title)
      atc_title.equal?pge_title
    end

    def verify_atc_color(selected_color)
      selected_color.include?(atc_color.split(':')[1])
    end

    def verify_atc_price(pge_price)
      (atc_price.gsub("$", "")).equal?pge_price
    end

    def increase_qty_atc
      prev = atc_selected_qty
      atc_increase_qty_element.click
      atc_suggestions_item_one_element.present?
      while atc_qty_spinner_element.present? do
        break if(!(atc_qty_spinner_element.present?))
      end
      atc_selected_qty.to_i.should == (prev.to_i + 1)
      atc_selected_qty
    end

    def decrease_qty_atc
      atc_decrease_qty_element.click if atc_decrease_qty_element.enabled?
      atc_selected_qty
    end

    def get_atc_subtotal
      (atc_subtotal).gsub("$", "")
    end

    def verify_atc_qty_price(actual_price, modified_qty)
      wait_until(!atc_decrease_qty_element.enabled?)
      subtotal = atc_subtotal.gsub("$", "").gsub(",","")

      ((atc_count).scan(/\d+/).first).should == modified_qty #check the item quantity under subtotal
      Log.instance.info("Increase quantity on ATC matches the product count below the Subtotal")

      (cart_qty).should == modified_qty #check the quantity in the My Cart icon
      Log.instance.info("Increasing quantity on ATC modal matches the count with Cart Icon")

      new_subtotal = modified_qty.to_i * actual_price.to_i
      Log.instance.info("Increase qty = #{modified_qty} :: New Subtotal : #{new_subtotal} :: Page Subtotal : #{subtotal.to_i}")
      new_subtotal.should == subtotal.to_i
    end

    def click_checkout
      atc_checkout_element.click
    end

    def click_continue_shopping
      atc_continue_shopping_element.click
    end

    def click_review_below_title
      title_review_count_element.click
    end

    def review_button?
      write_review_element.present?
    end

    def click_write_review
      write_review_element.click
    end

    def click_sort_review_option
      select_sort_btn_element.click
    end

    def select_review_sort_option(option)
      ### Available options
      # Most Relevant
      # Most Helpful
      # Highest to Lowest Rating
      # Lowest to Highest Rating
      # Featured
      # Oldest
      # Most Recent
      @browser.execute_script('window.scrollBy(arguments[0], arguments[1]);', 900, 900)
      sort_button_element.hover
      puts sort_button_element.elements
      sort_option_element.elements.each do |o|
        o.click if o.text.include?(option)
      end
    end

    def verify_sort_star_low_to_high
      stars = Array.new
      stars_sorted = Array.new
      sleep(1)
      displayed_star_reviews_elements.each do |r|
        stars.push(r.attribute('title').gsub!(" out of 5 stars."))
      end
      stars_sorted = stars
      stars.should == stars_sorted.sort
    end

  end
end