module ExecutionEnvironment
  extend self

  # The base URL the test session is testing against.
  def url
    # raise "The 'URL' environment variable was not specified on the cucumber command line." if ENV['URL'].nil?
    ENV['URL']
  end

  # Base log Directory
  def log_directory
    @log_directory ||= "#{Dir.getwd}/log"
  end

  # Returns the test execution timeout.  The default is 10 minutes, and can be overridden on the cucumber
  # command line with TEST_TIMEOUT=15
  def test_timeout_minutes
    ENV['TEST_TIMEOUT'].to_f
  end

  # Returns the operating system the test host is running on.
  # @return [Symbol] One of: :windows, :macosx, :linux, :unix
  def host_os
    @os ||= (
      case RbConfig::CONFIG['host_os']
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          :linux
        when /solaris|bsd/
          :unix
        else
          raise "Unknown os: #{RbConfig::CONFIG['host_os']}"
      end
    )
  end

  # The browser to run tests against.  One of :firefox, :chrome, :ie, or :safari.
  def browser_name
    env_browser = ENV['BROWSER'] || ENV['BROWSERNAME'] || ENV['BROWSER_NAME']
    env_browser.nil_or_empty? ? 'firefox'.to_sym : env_browser.downcase.to_sym
  end

end
