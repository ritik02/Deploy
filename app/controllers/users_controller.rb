
class UsersController < ApplicationController
  include EncryptionHelper
  include TokenValidationHelper
  include UrlValidatorHelper
  before_action :run_validations, except: [:index, :show]
  before_action :check_admin, only: [:index, :show]

  def index
    @user = current_user
    @users = User.all
    @users = User.where("lower(name) LIKE ?", "%#{params[:search_query].downcase}%") unless params[:search_query].blank?
  end

  def show
    @user = User.find(params[:id])
    @current_user = current_user
    @user_deployments = Deployment.order('deployments.updated_at DESC').where(user_id: @user.id)
    @user_reviews = Deployment.order('deployments.updated_at DESC').where(reviewer_id: @user.id)
  end

  def edit
    @user = current_user
  end

  def update
    pasted_gitlab_token = params["user"]["gitlab_token"]
    pasted_jira_token = params["user"]["jira_token"]
    return if !redirect_if_token_is_nil?(pasted_gitlab_token) || !redirect_if_token_is_invalid?(pasted_gitlab_token)
    response = @gitlab_api_services.get_user_details(current_user.username)
    return if !redirect_if_token_is_nil?(pasted_jira_token) || !redirect_if_jira_token_is_invalid?(pasted_jira_token, response.first["username"]+"@go-jek.com")
    current_user.update(
      name: response.first["name"],
      gitlab_user_id: response.first["id"].to_i,
      email: response.first["username"]+"@go-jek.com",
      gitlab_token: encrypt_access_token(pasted_gitlab_token),
      jira_token: encrypt_access_token(pasted_jira_token))
    redirect_to action: "index", controller: "projects", user_id: current_user.id
  end

  private

  def run_validations
    return if !validate_user_id?(current_user.id.to_s, params[:id])
  end

  def check_admin
    get_admins
    return if @admin.include?(current_user.email)
    run_validations if !params[:id].blank?
    redirect_to action: "index", controller: "projects", user_id: current_user.id.to_s if params[:id].blank?
  end
end
