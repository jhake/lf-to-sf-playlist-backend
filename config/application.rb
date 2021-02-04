require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LfToSfPlaylistBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    RSpotify::authenticate(ENV["spotify_client_id"], ENV["spotify_client_secret"])

    config.middleware.use Rack::Cors do
      allow do
        origins ENV["client_url"]
        resource "*",
                 headers: :any,
                 expose: %w(access-token expiry token-type uid client),
                 methods: %i(get post options put delete)
      end
    end
  end
end
