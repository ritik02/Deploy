class DeploymentsController < ApplicationController

	def new
		initialize_deployment
	end

  def create
    deployment = Deployment.find(params[:deployment_id])
		return if !reviewer_not_valid?
    checklist_json_string = params[:deployments].to_json
    deployment.update({checklist: checklist_json_string, status: "filled", reviewer_id: User.where(:email => params[:deployments][:reviewer_email]).first.id })
		redirect_to deployments_path(:user_id => current_user.id)
  end

	def index
		@deployments = Deployment.all
	end

	def destroy
     @deployment = Deployment.find(params[:id])
     @deployment.destroy
     redirect_to deployments_path
	end

	private

	def initialize_deployment
		@deployment = Deployment.new({user_id: params[:user_id], project_name: params[:project_name], commit_id: params[:commit_id], status: "created"})
		@deployment.save
		@user = current_user
	end

	def reviewer_not_valid?
		if User.where(:email => params[:deployments][:reviewer_email]).blank?
			render 'layouts/error'
			return false
		end
		return true
	end

end
