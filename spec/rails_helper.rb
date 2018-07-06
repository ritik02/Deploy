require 'simplecov'
SimpleCov.start
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require_relative '../app/services/gitlab_api_services'


ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Base.logger.level = Logger::INFO
ActionController::Base.logger.level = Logger::ERROR
Rails.logger.level = Logger::ERROR

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include EncryptionHelper
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
