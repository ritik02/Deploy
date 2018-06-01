require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

module Workplace
  class Application < Rails::Application
    config.load_defaults 5.2

  end
end
