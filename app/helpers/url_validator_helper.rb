module UrlValidatorHelper

  def validate_user_id?(current_user_id, param_user_id)
    if current_user_id == param_user_id
      return true
    else
      redirect_to action: "index", controller: "projects", user_id: current_user.id.to_s
      return false
    end
  end

  def project_id_valid?(project_id)
    @projects_details = @gitlab_api_services.get_project_details(project_id)
    if !@projects_details["message"].blank? && (@projects_details["message"].include?("404") || @projects_details["message"].include?("401") || @projects_details["message"].include?("403"))
      flash[:notice] = "Project Does Not Exist Or You Are Not Authorized To See It"
      render 'layouts/error'
      return false
    end
    return true
  end

  def pipeline_exist?(project_id)
    pipeline = @gitlab_api_services.get_project_pipelines(project_id)
    if pipeline.blank?
      flash[:notice] = "Sorry No Pipelines For This Project!"
      render 'layouts/error'
      return false
    end
    @pipeline = pipeline[0]
    return true
  end

  def deployment_exist?
    @deployments = @gitlab_api_services.get_all_deployments(@project_id)
    if @deployments.blank?
      flash[:notice] = "Sorry No Deployments For This Job!"
      render 'layouts/error'
      return false
    elsif @deployments.length==1 && !@deployments["message"].blank? && (@deployments["message"].include?("404") || @deployments["message"].include?("401") || @deployments["message"].include?("403"))
      flash[:notice] = "Sorry No Deployments For This Job Or You Are Not Authorized To See It!"
      render 'layouts/error'
      return false
    end
    return true
  end

end
