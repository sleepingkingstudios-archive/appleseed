require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Appleseed
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Remove the standard behavior for fields with errors.
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end # field error proc

    # Precompile assets from /vendor/assets.
    config.assets.precompile << 'foundation-icons.css'
    config.assets.precompile << 'webfonts.scss'
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

    config.i18n.enforce_available_locales = true
  end
end
