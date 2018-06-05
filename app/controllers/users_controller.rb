require 'httparty'
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

    url = "https://source.golabs.io/api/v4/users?private_token=" + copied_token + "&username=" + current_user.username
    response = HTTParty.get(url)
    User.find(current_user.id).update(:name => response.first["name"], :gitlab_userid => response.first["id"].to_i, :email => response.first["username"]+"@go-jek.com", :gitlab_token => encrypt_accesstoken(copied_token))
    redirect_to users_index_url
  end

  def pages(gitlab_userid, gitlab_token)
    url = "https://source.golabs.io/api/v4/users/" + gitlab_userid.to_s + "/projects?private_token=" + gitlab_token
    response = HTTParty.get(url)
    projects = response
    number_of_projects = projects.length
    @number_of_pages = number_of_projects / 1
    if number_of_projects % 1 != 0
      @number_of_pages = number_of_pages + 1
    end
    return @number_of_pages
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
    @user = current_user
    gitlab_userid = @user.gitlab_userid
    page_id = params[:page_id]
    if page_id == 0 || page_id == nil
        page_id = 1
    end
    @number_of_pages = pages(gitlab_userid, gitlab_token)
    url = "https://source.golabs.io/api/v4/users/" + gitlab_userid.to_s + "/projects?private_token=" + gitlab_token + "&per_page=1&page=" + page_id.to_s
    response = HTTParty.get(url)
    @projects = response
end

end
