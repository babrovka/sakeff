require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sakeff
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    
    # config.before_configuration do
    #   I18n.config.enforce_available_locales = false #@prdetective TODO: this will default to true in future rails versions
    #   I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    #   I18n.locale = :ru
    #   I18n.default_locale = :ru
    #   config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    #   config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    #   config.i18n.locale = :ru
    #   # bypasses rails bug with i18n in production\
    #   I18n.reload!
    #   config.i18n.reload!
    # end

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
    config.i18n.locale = :ru


    config.active_record.schema_format = :sql
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

  end
end
