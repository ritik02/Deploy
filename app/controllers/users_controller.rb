class UsersController < ApplicationController
  include UsersHelper

  def home
  end

  def index
    @gitlab_token = User.find(current_user.id).gitlab_token
    response = check_api_for_valid_token?(@gitlab_token)
    if response == false
      render 'home'
    end
  end

end
