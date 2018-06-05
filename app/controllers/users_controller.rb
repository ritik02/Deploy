require 'gitlab_api_services'
class UsersController < ApplicationController

  include UsersHelper

  def home
    @user = current_user
  end

  def update
    pasted_token = params["user"]["gitlab_token"]
    get_gitlab_api_services(pasted_token)
    response = @gitlab_api_services.check_api_for_valid_token?
    if response == false
      redirect_to users_home_path
      return
    end
    response = @gitlab_api_services.get_user_details(current_user.username)
    current_user.update(:name => response.first["name"], :gitlab_userid => response.first["id"].to_i, :email => response.first["username"]+"@go-jek.com", :gitlab_token => encrypt_access_token(pasted_token))
    redirect_to users_project_url
  end

  def project
    gitlab_token = current_user.gitlab_token
    if gitlab_token == nil || gitlab_token == ""
      redirect_to users_home_path
      return
    end
    get_gitlab_api_services(decrypt_access_token(gitlab_token))
    response = @gitlab_api_services.check_api_for_valid_token?
    if response == false
      redirect_to users_home_path
      return
    end
    page_id = params[:page_id]
    if page_id.blank?
        page_id = 1
    end
    @number_of_pages = @gitlab_api_services.get_number_of_pages(current_user.gitlab_userid)
    @projects = @gitlab_api_services.get_user_projects(current_user.gitlab_userid, page_id)
  end

  def get_gitlab_api_services(gitlab_token)
    @gitlab_api_services = GitlabApiServices.new(gitlab_token)
  end

end
