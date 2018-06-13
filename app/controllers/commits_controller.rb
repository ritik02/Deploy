class CommitsController < ApplicationController
 include TokenValidationHelper
 include EncryptionHelper

 before_action :validate_token_and_get_details

 def index
   @selected_job_name = params[:job_name]
   @deployments = @gitlab_api_services.get_all_deployments(@project_id)
   return if !get_last_deployed_commit_details?
   @all_commits_after_last_deployed_commit = @gitlab_api_services.get_all_commits_after_last_deployed_commit(@project_id, @time)
   @all_commits_after_last_deployed_commit.to_a.reverse!
 end

 def show
   @destination_commit = params[:id]
   @source_commit = params[:last_deployed_commit]
   @commit_diff = @gitlab_api_services.get_diff_of_two_commits(@project_id, @source_commit, @destination_commit)
 end

 private

 
def get_last_deployed_commit_details?
  @deployments.each do |deployment|
    if deployment["deployable"]["name"] == @selected_job_name
      @last_deployed_commit = deployment["deployable"]["commit"]
      @time = deployment["deployable"]["commit"]["created_at"]
      parse_time
      return true
    end
  end
  if @last_deployed_commit.blank? || @time.blank?
    render 'layouts/error'
    return false
  end
end

 def parse_time
   @time = @time[0..18] + "Z"
 end

 def validate_token_and_get_details
   return if redirect_if_token_is_nil?(decrypt_access_token(current_user.gitlab_token))
   return if redirect_if_token_is_invalid?(decrypt_access_token(current_user.gitlab_token))
   get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
   @project_id = params[:project_id]
   @user_id = params[:user_id]
   @user = current_user
   @project_name = params[:project_name]
 end

end