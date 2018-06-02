require 'simplecov'
SimpleCov.start
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'httparty'

class ActiveSupport::TestCase
  fixtures :all

  def check_api_for_valid_token? token
    url = "https://source.golabs.io/api/v4/users?private_token=" + token
    response = HTTParty.get(url)
    if response.code == 200
      return true
    else false
    end
  end

  def encrypt_accesstoken(token)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.access_token_base)
    encrypted_token = crypt.encrypt_and_sign(token || "XXXXX")
    return encrypted_token
  end

  def decrypt_accesstoken(encrypted_token)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.access_token_base)
    decrypted_token = crypt.decrypt_and_verify(encrypted_token || "XXXXX")
    return decrypted_token
  end


end
