module UrlValidatorHelper
  def get_admins
      @admin = ["archit.j.aux@go-jek.com","ritik.v.aux@go-jek.com","prakash.d.aux@go-jek.com"]
  end

  def validate_user_id?(current_user_id, param_user_id)
      return true if current_user_id == param_user_id
      redirect_to action: "index", controller: "projects", user_id: current_user.id.to_s
      return false
  end

  def project_id_valid?(project_id)
    @projects_details = @gitlab_api_services.get_project_details(project_id)
    if !@projects_details["message"].blank?
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
    if @deployments.blank? || @deployments.key?("message")
      flash[:notice] = "Sorry No Deployments For This Job Or You Are Not Authorized To See It!"
      render 'layouts/error'
      return false
    end
    return true
  end

end
