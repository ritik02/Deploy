class CommitsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper

  def index
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    @last_deployed_commit = @gitlab_api_services.get_last_deployed_commit(params[:project_id])
    parse_time
    @all_commits_after_last_deployed_commit = @gitlab_api_services.get_all_commits_after_last_deployed_commit(params[:project_id], @time)
  end

  private
  def parse_time
    @time = @last_deployed_commit["deployable"]["commit"]["created_at"]
		@time = @time[0..18] + "Z"
  end
end
