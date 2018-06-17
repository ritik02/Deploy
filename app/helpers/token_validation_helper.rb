module TokenValidationHelper
  def get_gitlab_api_services(gitlab_token)
    @gitlab_api_services = GitlabApiServices.new(gitlab_token)
  end

  def redirect_if_token_is_nil?(token)
    if token.blank?
      redirect_to action: "edit", controller: "users", id: current_user.id
      return false
    end
    return true
  end

  def redirect_if_token_is_invalid?(token)
    get_gitlab_api_services(token)
    if !@gitlab_api_services.check_api_for_valid_token?
      redirect_to action: "edit", controller: "users", id: current_user.id
      return false
    end
    return true
  end
end
