Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  config.cas_base_url = "https://sso.gojek.co.id/cas"
  config.cas_login_url = "https://sso.gojek.co.id/cas/login"
  require 'devise/orm/active_record'
  config.skip_session_storage = [:http_auth]
  config.reconfirmable = true
  config.stretches = Rails.env.test? ? 1 : 11
  config.expire_all_remember_me_on_sign_out = true
  config.sign_out_via = :delete
end
