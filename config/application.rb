require_relative 'boot'

require "rails"

%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

Bundler.require(*Rails.groups)
module Deploy
  class Application < Rails::Application
    config.load_defaults 5.2
    config.time_zone = 'Kolkata'
  end
end
