class CommitsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper

  before_action :validate_token_and_get_details

  def index
    #@last_deployed_commit = @gitlab_api_services.get_last_deployed_commit(params[:project_id])
    @last_deployed_commit = @gitlab_api_services.get_last_deployed_commit_dummy(@project_id)
    #parse_time
    parse_time_dummy
    @all_commits_after_last_deployed_commit = @gitlab_api_services.get_all_commits_after_last_deployed_commit(@project_id, @time)
    @all_commits_after_last_deployed_commit.to_a.reverse!
  end

  def show
    @destination_commit = params[:id]
    @source_commit = @gitlab_api_services.get_last_deployed_commit_dummy(params[:project_id])["short_id"]
    @commit_diff = @gitlab_api_services.get_diff_of_two_commits(@project_id, @source_commit, @destination_commit)
  end

  private

  def parse_time
    @time = @last_deployed_commit["deployable"]["commit"]["created_at"]
		@time = @time[0..18] + "Z"
  end

  def parse_time_dummy
    @time = @last_deployed_commit["created_at"]
    @time = @time[0..18] + "Z"
  end

  def validate_token_and_get_details
    return if redirect_if_token_is_nil?(decrypt_access_token(current_user.gitlab_token))
    return if redirect_if_token_is_invalid?(decrypt_access_token(current_user.gitlab_token))
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    @project_id = params[:project_id]
    @user_id = params[:user_id]
    @user = current_user
  end
end
