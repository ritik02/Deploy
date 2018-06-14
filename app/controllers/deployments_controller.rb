class DeploymentsController < ApplicationController

def new
  @deployment = Deployment.new({user_id: params[:user_id], project_name: params[:project_name], commit_id: params[:commit_id], status: "Created", diff_link: request.original_url})
  @deployment.save
  @user = current_user
  UserMailer.sample_email(current_user).deliver
end

def create
	deployment = Deployment.find(params[:deployment_id])
	return if !reviewer_not_valid?
	checklist_json_string = params[:deployments].to_json
	deployment.update({checklist: checklist_json_string, status: "Checklist Filled", reviewer_id: User.where(:email => params[:deployments][:reviewer_email]).first.id })
	redirect_to deployments_path(:user_id => current_user.id)
end

def index
  @deployments = Deployment.where(:user_id => current_user.id)
  @user = current_user
end

def destroy
	@deployment = Deployment.find(params[:id])
	@deployment.destroy
	redirect_to deployments_path
end

def show
  @deployment = Deployment.find(params[:id])
  if current_user.id != @deployment.reviewer_id
    render 'layouts/error'
  end
end

private

def reviewer_not_valid?
  if User.where(:email => params[:deployments][:reviewer_email]).blank?
    render 'layouts/error'
    return false
  end
  return true
end

end