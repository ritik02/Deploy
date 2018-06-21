class CommitsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper
  include UrlValidatorHelper
  before_action :validate_and_get_details

  def index
    @selected_job_name = params[:job_name]
    return if !deployment_exist? || !get_last_deployed_commit_details?
    @all_commits_after_last_deployed_commit = @gitlab_api_services.get_all_commits_after_last_deployed_commit(@project_id, @time)
  end

  def show
    @destination_commit = params[:id]
    @source_commit = params[:last_deployed_commit]
    @job_name = params[:job_name]
    @commit_diff = @gitlab_api_services.get_diff_of_two_commits(@project_id, @source_commit, @destination_commit)
  end

  private

  def get_last_deployed_commit_details?
    @deployments.each do |deployment|
      if deployment["deployable"]["name"] == @selected_job_name
        @last_deployed_commit = deployment["deployable"]["commit"]
        @time = deployment["deployable"]["commit"]["created_at"]
        return true
      end
    end
    return false if !got_last_deployed_commit?
  end

  def got_last_deployed_commit?
    if @last_deployed_commit.blank? || @time.blank?
      flash[:notice] = "Sorry no deployments found!"
      render 'layouts/error'
      return false
    end
  end

  def validate_and_get_details
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    return if (!validate_user_id?(current_user.id.to_s, params[:user_id]) ||
                !project_id_valid?(params[:project_id]) ||
                !redirect_if_token_is_nil?(decrypt_access_token(current_user.gitlab_token)) ||
                !redirect_if_token_is_invalid?(decrypt_access_token(current_user.gitlab_token)))
  end

  def get_details
    @project_id = params[:project_id]
    @user_id = params[:user_id]
    @user = current_user
    @project_name = params[:project_name]
  end

end
