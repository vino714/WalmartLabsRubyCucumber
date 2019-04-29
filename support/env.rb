require 'rubygems'
require 'selenium-webdriver'
require 'page-object'
require 'rspec'
require 'rspec/expectations'
require 'require_all'
require 'logger'
require_all 'lib/pages'
require_all 'lib/utils'
require 'time'
require 'colorize'

World(PageObject::PageFactory)

PageObject.default_element_wait = 10
PageObject.default_page_wait = 60

Dir.mkdir(ExecutionEnvironment.log_directory) unless Dir.exists?(ExecutionEnvironment.log_directory)