class ProjectsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper
  include UrlValidatorHelper
  before_action  :get_details, :run_validations

  def index
    return if got_search_query?(params[:search_query])
    get_page_id(params[:page_id])
    @projects = @gitlab_api_services.get_user_projects(@user.gitlab_user_id, @page_id)
  end

  def show
    project_id = params["id"]
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    return if !project_id_valid?(project_id) || !pipeline_exist?(project_id)
    @project_deployments = Deployment.where(project_id: project_id)
    jobs = @gitlab_api_services.get_jobs_of_a_pipeline(project_id, @pipeline["id"])
    map_stages_with_jobs(jobs)
  end

  private

  def got_search_query?(search_query)
    return false if search_query.blank?
    @projects = @gitlab_api_services.get_search_results(@user.gitlab_user_id, search_query)
    @number_of_pages = 0
    return true
  end

  def get_page_id(page_id)
    @page_id = page_id.blank? ? 1 : page_id
  end

  def map_stages_with_jobs(pipeline_jobs)
    @stages = {}
    pipeline_jobs.each do |job|
      unless @stages.key?(job["stage"])
        @stages.merge!(job["stage"] => [])
      end
      @stages[job["stage"]].push(job)
    end
    @stages
  end

  def run_validations
    return if !validate_user_id?(current_user.id.to_s, params[:user_id]) ||
              !redirect_if_token_is_nil?(@user.gitlab_token) ||
              !redirect_if_token_is_invalid?(decrypt_access_token(@user.gitlab_token))
  end

  def get_details
      @user = current_user
  end

end
