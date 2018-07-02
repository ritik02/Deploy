Rails.application.configure do
 config.cache_classes = true
 config.eager_load = true
 config.consider_all_requests_local       = false
 config.action_controller.perform_caching = true
 config.serve_static_assets = true
 config.serve_static_files = true
 config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
 config.assets.js_compressor = :uglifier
 config.assets.compile = false
 config.assets.digest = true
 config.log_level = :debug
 config.log_tags = [ :request_id ]
 config.action_mailer.perform_caching = false
 config.i18n.fallbacks = true
 config.require_master_key = true
 config.active_support.deprecation = :notify
 config.log_formatter = ::Logger::Formatter.new
 if ENV["RAILS_LOG_TO_STDOUT"].present?
   logger           = ActiveSupport::Logger.new(STDOUT)
   logger.formatter = config.log_formatter
   config.logger    = ActiveSupport::TaggedLogging.new(logger)
 end
 config.active_record.dump_schema_after_migration = false
 config.action_mailer.default_url_options = { :host => 'localhost:3000' }
 config.action_mailer.delivery_method = :smtp
 config.action_mailer.raise_delivery_errors = false
 config.action_mailer.perform_caching = false
 config.action_mailer.perform_deliveries = true
 config.action_mailer.default :charset => "utf-8"
 config.action_mailer.smtp_settings = {
 address: Figaro.env.smtp_address,
 port: Figaro.env.smtp_port,
 domain: Figaro.env.smtp_domain,
 authentication: "plain",
 enable_starttls_auto: true,
 user_name: Figaro.env.smtp_user_name,
 password: Figaro.env.smtp_password
}
end