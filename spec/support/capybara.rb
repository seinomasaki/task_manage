require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 15

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('--disable-gpu')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end