require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OnePiece
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.i18n.default_locale = 'zh-CN'
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.eager_load_paths << Rails.root.join("lib")
  end
end
