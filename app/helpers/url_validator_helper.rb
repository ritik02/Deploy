module UrlValidatorHelper
  def validate_user_id?(current_user_id, param_user_id)
    if current_user_id == param_user_id
      return true
    else
      redirect_to action: "index", controller: "projects", user_id: current_user.id.to_s
      return false
    end
  end

end
