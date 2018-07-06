
class UsersController < ApplicationController
  include EncryptionHelper
  include TokenValidationHelper
  include UrlValidatorHelper
  before_action :run_validations, except: [:index, :show, :make_admin]
  before_action :check_admin, only: [:index, :show]

  def index
    @user = current_user
    @users = User.all.paginate(:page => params[:page], :per_page => 20)
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
      email: current_user.username + "@go-jek.com",
      gitlab_token: encrypt_access_token(pasted_gitlab_token),
      jira_token: encrypt_access_token(pasted_jira_token))
    redirect_to action: "index", controller: "projects", user_id: current_user.id
  end

  def make_admin
    user = User.find(params[:id])
    user.update({admin: true})
    puts user.admin
    redirect_to users_path
  end

  private

  def run_validations
    return if !validate_user_id?(current_user.id.to_s, params[:id])
  end

  def check_admin
    return if current_user.admin
    run_validations if !params[:id].blank?
    redirect_to action: "index", controller: "projects", user_id: current_user.id.to_s if params[:id].blank?
  end
end
