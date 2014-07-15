require 'spec_helper'
require 'database_cleaner'
require 'capybara/poltergeist'
require 'capybara/rails'

include Rails.application.routes.url_helpers

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  #Capybara.register_driver :poltergeist do |app|
  #  Capybara::Poltergeist::Driver.new(app, js_errors: false)
  #end

  Capybara.ignore_hidden_elements = false

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include Features::SelectDatesAndTimesHelper, type: :feature
  config.include Features::SessionsHelper, type: :feature
  config.include Features::ScreenshotsHelper, type: :feature
  config.include Features::ChosenHelper, type: :feature


  # устанавлиаем дефолтное разрешение экрана,под которым будут испольняться js тесты
  config.before(:each, js: true) do
    page.driver.resize(1280, 1024)
  end

  # autosave errors screenshots
  # source http://viget.com/extend/auto-saving-screenshots-on-test-failures-other-capybara-tricks
  config.after(:each) do
    if example.exception && example.metadata[:js]
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      screenshot_name = "#{filename}-#{line_number}.png"
      screenshot_path = "#{Rails.root.join("test_images")}/#{screenshot_name}"

      page.save_screenshot(screenshot_path, full: true)

      puts meta[:full_description] + "\n  Screenshot: #{screenshot_path}"
    end
  end

end
