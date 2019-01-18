#!/usr/bin/env ruby

# Automates the check-in process for Southwest flights
#
# Uses a headless chrome browser powered by `chromedriver` and emails you
# a screenshot of the result (hopefully a successful check-in)
#
# === Dependencies
#
#   1. Ruby
#   2. `selenium-webdriver` ruby gem. Install with `gem install selenium-webdriver`
#   3. `chromdriver`. On OSX you can `brew install chromedriver`. On Debian Linux
#      it's slightly more involved. See: https://christopher.su/2015/selenium-chromedriver-ubuntu/
#   4. `mailx` - Installed by default on OSX. On debian linux you can `sudo apt-get install heirloom-mailx`
#
# === Scheduling
#
# The script requires your name, Southwest confirmation code, and email to run
# You can use `cron` on any other scheduling utility to run this script
#
#
#     SWA_CONFIRMATION="abcde" \
#       SWA_FIRST_NAME="Darth" \
#       SWA_LAST_NAME="Vadar" \
#       SWA_EMAIL_RECIPIENTS="foo@example.com" \
#       path/to/swa.rb

require "selenium-webdriver"

class SouthwestCheckInTask
  attr_accessor :logger, :driver, :config

  def initialize
    setup_logger

    validate_environment

    check_for_chromedriver
    check_for_mailx
    setup_driver
    setup_headless_window
  end

  def run!
    run_and_close_driver do
      logger.info("Visiting SWA website")
      visit("https://southwest.com")

      logger.debug("Clicking Check-In Tab")
      checkin_el = driver.find_element(id: "booking-form--check-in-tab")
      checkin_el.click

      logger.debug("Fill out flight info")

      confirmation_field = driver.find_element(id: "confirmationNumber")
      fname_field = driver.find_element(id: "firstName")
      lname_field = driver.find_element(id: "lastName")
      submit = driver.find_element(id: "jb-button-check-in")

      confirmation_field.send_keys(confirmation)
      fname_field.send_keys(fname)
      lname_field.send_keys(lname)
      submit.click

      sleep 3.0

      # There's no id for this button element, but for now it's the only
      # `submit-button` class on the page. Fingers crossed it stays that way.
      submit = driver.find_element(:class, "submit-button")
      submit.click

      sleep 3.0

      @success = true
    end
  end

  private

  def confirmation
    @confirmation ||= ENV["SWA_CONFIRMATION"]
  end

  def fname
    @fname ||= ENV["SWA_FIRST_NAME"]
  end

  def lname
    @lname ||= ENV["SWA_LAST_NAME"]
  end

  def recipients
    @recipients ||= ENV["SWA_EMAIL_RECIPIENTS"]
  end

  def validate_environment
    logger.debug("Checking if ENV variables are set")

    if !confirmation || !fname || !lname || !recipients
      logger.fatal("Please set `SWA_CONFIRMATION`, `SWA_FIRST_NAME`, "\
        "`SWA_LAST_NAME`, `SWA_EMAIL_RECIPIENTS`")
      exit(1)
    end
  end

  def check_for_chromedriver
    logger.debug("Checking if `chromedriver` is available")

    if !`which chromedriver`
      logger.fatal("Can not find `chromedriver`")
      exit(1)
    end
  end

  def check_for_mailx
    logger.debug("Checking if `mailx` is available")

    if !`which mailx`
      logger.fatal("Can not find `mailx`")
      exit(1)
    end
  end

  def setup_logger
    @logger_filepath = "/tmp/swa-#{Time.now.utc.to_i}.log"
    puts "Logging to #{@logger_filepath}"
    @logger = Logger.new(@logger_filepath)
    @logger.info("Logging enabled")
  end

  def setup_driver
    logger.debug("Creating driver")

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @driver = Selenium::WebDriver.for(:chrome, options: options)
  end

  def setup_headless_window
    width = 1600
    height = 1280
    logger.debug("Resizing window to #{width}x#{height}")
    driver.manage.window.resize_to(width, height)
  end

  # Executes a block and ensures the headless browser connection is closed
  # before exiting.
  def run_and_close_driver(&block)
    logger.info("Starting execution")
    yield
    logger.info "Complete!"
  rescue => e
    logger.error e
    logger.error e.backtrace
  ensure
    capture_screenshot!

    if driver
      logger.info("Closing driver...")
      driver.quit
    end

    send_mail
  end

  def visit(url, log: true)
    logger.debug("Visiting #{url}") if log
    driver.navigate.to(url)
  end

  def capture_screenshot!
    @screenshot_filename = "screenshot-#{Time.now.utc.to_i}.png"
    @screenshot_filepath = File.join("/tmp", @screenshot_filename)

    logger.debug "Capturing screenshot... #{@screenshot_filepath}"
    puts "Capturing screenshot... #{@screenshot_filepath}"
    driver.save_screenshot(@screenshot_filepath) if driver
  end

  def send_mail
    subject = @success ? "Successfully Checked In" : "Attempted Checking In"
    cmd = "cat #{@logger_filepath} | mailx -s \"#{subject}\" #{recipients}"

    logger.debug("mailx command: '#{cmd}'")
    `#{cmd}`
  end
end

SouthwestCheckInTask.new.run!
