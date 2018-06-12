class DeploymentsController < ApplicationController

	def new
		initialize_deployment
	end

	def create
		deployment = Deployment.find(params[:deployment_id])
		checklist_json_string = params[:deployments].to_json
		deployment.update({checklist: checklist_json_string, status: "filled"})
	end

	private

	def initialize_deployment
		@deployment = Deployment.new({user_id: params[:user_id], project_id: params[:project_id], commit_id: params[:commit_id], status: "created"})
		@deployment.save
		@user = current_user
	end

end
