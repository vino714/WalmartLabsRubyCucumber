# require 'benchmark'
# require 'cucumber/formatter/html'
# require 'cucumber/runtime/results'

Before do |scenario, tags|
  #Dir.mkdir(ExecutionEnvironment.log_directory) unless Dir.exists?(ExecutionEnvironment.log_directory)
  @log = Log.instance.start_new(ExecutionEnvironment.log_directory)
  @log.debug "Scenario:  #{scenario.name}"
  @log.debug "URL:  #{ExecutionEnvironment.url}"
  @log.info ""
  @browser = Browser.setup(ExecutionEnvironment.browser_name)
end

# Important - the After step should not throw any errors.  Verify the @browser instance is not nil
# before using it, catch any errors thrown from taking screenshots, etc.
After do |scenario|
    @log.error "Exception: #{scenario.exception}\n" + scenario.exception.backtrace.join("\n") if scenario.failed?
    @log.debug ''
    @log.debug "Finished Scenario: #{scenario.name}"
    @log.debug "Status: #{scenario.status}"

    if scenario.failed?
      timestamp = Time.now.strftime('%Y_%m_%d-%HH_%MM_%SS')
      if @browser.nil?
        @log.warn "Unable to take browser screenshot because the browser was not set up correctly."
      else
        encoded_img = @browser.screenshot_as(:base64)
        embed("data:image/png;base64,#{encoded_img}",'image/png', "Screenshot") rescue false
      end
    end

    embed(File.basename(Log.instance.log_file_path), 'text/plain', "Log File") rescue nil

    unless @browser.nil?
        Browser.quit_browser
    end
end

at_exit do

end