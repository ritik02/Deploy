module TokenValidationHelper
  def get_gitlab_api_services(gitlab_token)
    @gitlab_api_services = GitlabApiServices.new(gitlab_token)
  end

  def get_jira_api_services(jira_token, user_email)
    @jira_api_services = JiraApiServices.new(jira_token, user_email)
  end

  def redirect_if_token_is_nil?(token)
    return true if !token.blank?
    flash[:notice] = "Token field cannot be empty."
    redirect_to action: "edit", controller: "users", id: current_user.id
    return false
  end
  
  def redirect_if_token_is_invalid?(token)
    get_gitlab_api_services(token)
    return true if @gitlab_api_services.check_api_for_valid_token?
    flash[:notice] = "Oops! Seems like your Gitlab token has expired or was revoked"
    redirect_to action: "edit", controller: "users", id: current_user.id
    return false
  end

  def redirect_if_jira_token_is_invalid?(token, user_email)
    get_jira_api_services(token, user_email)
    return true  if @jira_api_services.check_api_for_valid_token?
    flash[:notice] = "Oops! Seems like your Jira token was revoked"
    redirect_to action: "edit", controller: "users", id: current_user.id
    return false
  end
end
