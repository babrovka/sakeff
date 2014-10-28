require 'spec_helper'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Этот хук добавлен для того, чтобы открывались формы логина пользователей.
# Иначе выдавалась ошибка про main_app
#
# подсмотрено по ссылке
# http://stackoverflow.com/questions/16174184/main-app-namespace-unknown-in-rspec-only-in-unit-suite-tests-batch
# def main_app
#   Rails.application.class.routes.url_helpers
# end
# конец хука


# Тестирование с упрощенним логированием
# https : // github.com/plataformatec/devise/wiki/How-To : -Test-with-Capybara
include Warden::Test::Helpers
Warden.test_mode!

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    # debug: true,
                                    # inspector: true,
                                    timeout: 60,
                                    '--proxy-type' => 'socks5',
                                    '--proxy' => '0.0.0.0:0'
  )
end

RSpec.configure do |config|

  Capybara.ignore_hidden_elements = false
  Capybara.javascript_driver = :poltergeist_debug


  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # загружаем все права из xls файла
    # потому что на них завязан код исполнения
    # тесты будут работать с настоящими правами
    Importers::PermissionImporter.import
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    Importers::PermissionImporter.import
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
    # загружаем все права из xls файла
    # потому что на них завязан код исполнения
    # тесты будут работать с настоящими правами
    Importers::PermissionImporter.import
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
  config.include FactoryGirl::Syntax::Methods, type: :feature
  config.include Rails.application.routes.url_helpers

  # устанавлиаем дефолтное разрешение экрана,под которым будут испольняться js тесты
  config.before(:each, js: true) do
    page.driver.resize(1280, 1024)
  end

  # autosave errors screenshots
  # source http://viget.com/extend/auto-saving-screenshots-on-test-failures-other-capybara-tricks
  config.after(:each) do |block|
    example = RSpec.current_example # специально для RSpec 3.0
    if example.exception && example.metadata[:js]
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      screenshot_name = "#{filename}-#{line_number}.png"
      screenshot_path = "#{Rails.root.join("test_images")}/#{screenshot_name}"

      page.save_screenshot(screenshot_path, full: true)

      puts meta[:full_description] + "\n  Screenshot: #{screenshot_path}"
    end

    # разлогиниваемся
    Warden.test_reset!
  end


end
