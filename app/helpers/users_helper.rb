module UsersHelper

  def encrypt_access_token(token)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.access_token_base)
    encrypted_token = crypt.encrypt_and_sign(token)
    return encrypted_token
  end

  def decrypt_access_token(encrypted_token)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.access_token_base)
    decrypted_token = crypt.decrypt_and_verify(encrypted_token)
    return decrypted_token
  end

end
