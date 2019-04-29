require 'timeout'

module Browser
  #
  # Closes browser at the end of test.
  #
  def self.close_browser
    @browser.close
  end

  #
  # Quits browser at the end of test without closing the window.
  #
  def self.quit_browser
    @browser.quit
  end

  #
  # Sets up a browser instance, enabling any necessary browser capabilities.
  # @param [Symbol] browser One of: :firefox, :chrome
  #
  def self.setup(browser = ExecutionEnvironment.browser_name, clear_cookies = true)
    if browser == :none
      nil
    else
      begin
        @browser = self.send "setup_#{browser.to_s}"
        @browser.manage.delete_all_cookies if clear_cookies unless ExecutionEnvironment.browser_name == :safari
        @browser.manage.window.maximize
        @browser.manage.timeouts.implicit_wait = 3
        @browser
      rescue Timeout::Error
        raise $!, "Unable to acquire browser session."
      end
    end
  end


  class << self
    private

    def setup_firefox
      profile = Selenium::WebDriver::Firefox::Profile.new
      Selenium::WebDriver.for :firefox, :profile => profile
    end

    def setup_chrome
      Selenium::WebDriver.for :chrome
    end

  end
end
