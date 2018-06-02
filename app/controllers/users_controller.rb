require 'httparty'
class UsersController < ApplicationController
  include UsersHelper

  def home
    @user = User.find(current_user.id)
    gitlab_token = User.find(current_user.id).gitlab_token
    response = check_api_for_valid_token?(gitlab_token)
    if response == true
      redirect_to users_index_url
      return
    end
  end

  def update
    copied_token = params["user"]["gitlab_token"]
    User.find(current_user.id).update(:gitlab_token => copied_token)
    response = check_api_for_valid_token?(copied_token)
    if response == false
      redirect_to users_home_path
      return
    end

    url = "https://source.golabs.io/api/v4/users?private_token=" + copied_token + "&username=" + current_user.username
    response = HTTParty.get(url)
    User.find(current_user.id).update(:name => response.first["name"], :gitlab_userid => response.first["id"].to_i, :email => response.first["username"]+"@go-jek.com")
    redirect_to users_index_url
  end

  def index
    gitlab_token = User.find(current_user.id).gitlab_token
    response = check_api_for_valid_token?(gitlab_token)
    if response == false
      redirect_to users_home_path
      return
    end

    @user = current_user
    gitlab_userid = @user.gitlab_userid
    url = "https://source.golabs.io/api/v4/users/" + gitlab_userid.to_s + "/projects?private_token=" + gitlab_token
    response = HTTParty.get(url)
    @projects = response
  end

end
