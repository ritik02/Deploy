class ProjectsController < ApplicationController
  include TokenValidationHelper
  include EncryptionHelper

  def index
    @user = current_user
    return if redirect_if_token_is_nil?(@user.gitlab_token)
    return if redirect_if_token_is_invalid?(decrypt_access_token(@user.gitlab_token))
    return if got_search_query?(params[:search_query])
    get_page_id(params[:page_id])
    @number_of_pages = @gitlab_api_services.get_number_of_pages(@user.gitlab_user_id)
    @projects = @gitlab_api_services.get_user_projects(@user.gitlab_user_id, @page_id)
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

end
