class DeploymentsController < ApplicationController
	include QuestionMapperHelper
	include UrlValidatorHelper
	include EncryptionHelper
	include TokenValidationHelper
	before_action :get_details

	def new
		@deployment = Deployment.new({user_id: current_user.id, project_name: params[:project_name], commit_id: params[:commit_id], status: "Created" })
	end

	def create
		return if !params_valid?(params)
		git_diff_link = generate_diff_link(params)
		deployment = Deployment.create!(user_id: current_user.id, project_name: params[:project_name], commit_id: params[:commit_id], status: "CheckList Filled" ,diff_link: git_diff_link, checklist: params[:deployments].to_json, reviewer_id: User.where(:email => params[:deployments][:reviewer_email]).first.id )
		UserMailer.deployment_request_email(deployment).deliver
		deployment.update({status: "Pending Approval"})
		redirect_to deployments_path
	end

	def index
		@deployments = Deployment.order('deployments.updated_at DESC').where(:user_id => current_user.id)
	end

	def show
		@deployment = Deployment.find(params[:id])
		get_question_mapper
	end

	def update
		deployment = Deployment.find(params[:id])
		deployment.update(:status => params[:status]) if current_user.id == deployment.reviewer_id
		UserMailer.status_mail(deployment).deliver
		redirect_to deployment_url(:id => deployment.id)
	end

	private

	def params_valid?(params)
		if User.where(:email => params[:deployments][:reviewer_email]).blank? || current_user.id.to_s != params[:user_id]
			redirect_to new_deployment_path(user_id: current_user.id, project_name: params[:project_name], commit_id: params[:commit_id], diff_link: params[:diff_link], last_deployed_commit: params[:last_deployed_commit], project_id: params[:project_id])
			return false
		end
		return true
	end

	def get_details
		@user = current_user
		@last_deployed_commit = params[:last_deployed_commit]
		@project_id = params[:project_id]
	end

	def generate_diff_link(params)
		git_diff_link =  "http://172.16.12.161:3000/users/"+ User.where(:email => params[:deployments][:reviewer_email]).first.id.to_s + "/projects/" + params[:project_id] + "/commits/" + params[:commit_id] + "?last_deployed_commit=" + params[:last_deployed_commit] + "&project_name=" + params[:project_name]
		git_diff_link
	end

end
