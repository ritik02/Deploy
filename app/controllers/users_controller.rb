require 'httparty'
require 'gitlab_api_services'
class UsersController < ApplicationController

  include UsersHelper

  def home
    @user = User.find(current_user.id)
    gitlab_token = User.find(current_user.id).gitlab_token
    if gitlab_token != nil && gitlab_token != ""
      response = check_api_for_valid_token?(decrypt_accesstoken(gitlab_token))
      if response == true
        redirect_to users_index_url
        return
      end
    end
  end

  def update
    copied_token = params["user"]["gitlab_token"]
    response = check_api_for_valid_token?(copied_token)
    if response == false
      redirect_to users_home_path
      return
    end
    get_gitlab_api_services(copied_token)
    response = @gitlab_api_services.get_user_details(current_user.username)
    User.find(current_user.id).update(:name => response.first["name"], :gitlab_userid => response.first["id"].to_i, :email => response.first["username"]+"@go-jek.com", :gitlab_token => encrypt_accesstoken(copied_token))
    redirect_to users_index_url
  end



  def index
    gitlab_token = User.find(current_user.id).gitlab_token
    if gitlab_token == nil || gitlab_token == ""
      redirect_to users_home_path
      return
    end
    gitlab_token = decrypt_accesstoken(gitlab_token)
    response = check_api_for_valid_token?(gitlab_token)
    if response == false
      redirect_to users_home_path
      return
    end
    page_id = params[:page_id]
    if page_id == 0 || page_id == nil
        page_id = 1
    end
    get_gitlab_api_services(decrypt_accesstoken(current_user.gitlab_token))
    @number_of_pages = @gitlab_api_services.get_number_of_pages(current_user.gitlab_userid)
    @projects = @gitlab_api_services.get_user_projects(current_user.gitlab_userid, page_id)
  end

  def get_gitlab_api_services(gitlab_token)
    @gitlab_api_services = GitlabApiServices.new(gitlab_token)
  end

end
