require 'set'
class ProjectsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper

  before_action :validate_token_and_get_user_details

  def index
    return if got_search_query?(params[:search_query])
    get_page_id(params[:page_id])
    @projects = @gitlab_api_services.get_user_projects(@user.gitlab_user_id, @page_id)
  end

  def show
    project_id = params["id"]
    get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
    @projects_details = @gitlab_api_services.get_project_details(project_id)
    @pipelines = @gitlab_api_services.get_project_pipelines(project_id)
    get_jobs_and_stages_of_a_pipelines(@pipelines, project_id)
  end

  private

  def got_search_query?(search_query)
    if !search_query.blank?
      @projects = @gitlab_api_services.get_search_results(@user.gitlab_user_id, search_query)
      @number_of_pages = 0
      return true
    end
    return false
  end

  def get_page_id(page_id)
    @page_id = page_id.blank? ? 1 : page_id
  end

  def get_jobs_and_stages_of_a_pipelines(pipelines, project_id)
    @stages_hash = {}
    @jobs_hash = {}
    pipelines.each do |pipeline|
      jobs = @gitlab_api_services.get_jobs_of_a_pipeline(project_id, pipeline["id"])
      @jobs_hash.merge!(pipeline["id"] => jobs)
      @stages_hash.merge!(pipeline["id"] => get_stages_of_pipeline(jobs))
    end
  end

  def get_stages_of_pipeline(pipeline_jobs)
    stages = Set[]
    pipeline_jobs.each do |job|
      stages.add(job["stage"])
    end
    stages.to_a
  end

  def validate_token_and_get_user_details
    @user = current_user
    return if redirect_if_token_is_nil?(@user.gitlab_token)
    return if redirect_if_token_is_invalid?(decrypt_access_token(@user.gitlab_token))
  end

end
