require 'gitlab_api_services'

class UsersController < ApplicationController
  include EncryptionHelper
  include TokenValidationHelper
  include UrlValidatorHelper
  before_action :run_validations, except: [:index]

  def index
    @users = User.all
  end

  def show
    @user = current_user
    @user_deployments = Deployment.order('deployments.updated_at DESC').where(user_id: @user.id)
    @user_reviews = Deployment.order('deployments.updated_at DESC').where(reviewer_id: @user.id)
  end

  def edit
    @user = current_user
  end

  def update
    pasted_token = params["user"]["gitlab_token"]
    return if !redirect_if_token_is_nil?(pasted_token) || !redirect_if_token_is_invalid?(pasted_token)
    response = @gitlab_api_services.get_user_details(current_user.username)
    current_user.update(
      name: response.first["name"],
      gitlab_user_id: response.first["id"].to_i,
      email: response.first["username"]+"@go-jek.com",
      gitlab_token: encrypt_access_token(pasted_token))
    redirect_to action: "index", controller: "projects", user_id: current_user.id
  end

  private 

  def run_validations
    return if !validate_user_id?(current_user.id.to_s, params[:id])
  end
end
