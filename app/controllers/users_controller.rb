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
    redirect_to users_index_url
  end

  def index
    gitlab_token = User.find(current_user.id).gitlab_token
    response = check_api_for_valid_token?(gitlab_token)
    if response == false
      redirect_to users_home_path
    end
  end

end
