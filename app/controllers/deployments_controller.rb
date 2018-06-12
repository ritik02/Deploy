class DeploymentsController < ApplicationController

	def new
		initialize_deployment
	end

	private

	def initialize_deployment
		@deployment = Deployment.new({user_id: params[:user_id], project_id: params[:project_id], commit_id: params[:commit_id]})
		@deployment.save
		@user = current_user
	end
end
