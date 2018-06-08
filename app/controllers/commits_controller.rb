class CommitsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper

  before_action :get_project_details

  def index
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    #@last_deployed_commit = @gitlab_api_services.get_last_deployed_commit(params[:project_id])
    @last_deployed_commit = @gitlab_api_services.get_last_deployed_commit_dummy(@project_id)
    #parse_time
    parse_time_dummy
    @all_commits_after_last_deployed_commit = @gitlab_api_services.get_all_commits_after_last_deployed_commit(@project_id, @time)
  end

  def show
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    @destination_commit = params[:id]
    @source_commit = @gitlab_api_services.get_last_deployed_commit_dummy(params[:project_id])["short_id"]
    puts @source_commit
    puts @destination_commit
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

  def get_project_details
    @project_id = params[:project_id]
    @user_id = params[:user_id]
  end
end
