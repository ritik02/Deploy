require 'gitlab_api_services'

class UsersController < ApplicationController
  include EncryptionHelper
  include TokenValidationHelper

  def edit
    @user = current_user
  end

  def update
    pasted_token = params["user"]["gitlab_token"]
    return if redirect_if_token_is_nil?(pasted_token)
    return if redirect_if_token_is_invalid?(pasted_token)
    response = @gitlab_api_services.get_user_details(current_user.username)
    current_user.update(name: response.first["name"], :gitlab_user_id => response.first["id"].to_i, :email => response.first["username"]+"@go-jek.com", :gitlab_token => encrypt_access_token(pasted_token))
    redirect_to action: "index", controller: "projects", user_id: current_user.id
  end
end
