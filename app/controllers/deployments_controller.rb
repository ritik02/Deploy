class DeploymentsController < ApplicationController
	include QuestionMapperHelper
	include UrlValidatorHelper
	include EncryptionHelper
	include TokenValidationHelper
	include SlackNotifierService
	before_action :get_details
	before_action :check_admin, only: [:index]

	def new
		return if !redirect_if_jira_token_is_invalid?(decrypt_access_token(@user.jira_token), @user.email)
		@deployment = Deployment.new({user_id: current_user.id,
			project_id: params[:project_id],
			project_name: params[:project_name],
			commit_id: params[:commit_id],
			status: "Created" ,
			job_name: params[:job_name]})
	end

	def create
		return if !params_valid?(params)
		git_diff_link = generate_diff_link(params)
		deployment = Deployment.create!(user_id: current_user.id,
			project_id: params[:project_id],
			project_name: params[:project_name],
			commit_id: params[:commit_id],
			status: "Pending Approval",
			diff_link: git_diff_link,
			checklist: params[:deployments].to_json,
			job_name: params[:job_name],
			reviewer_id: User.where(:email => params[:deployments][:reviewer_email]).first.id)
		jira_link = create_issue(params, deployment)
		deployment.update(jira_link: jira_link)
		UserMailer.deployment_request_email(deployment).deliver
		redirect_to user_path(id: @user.id)
	end

	def index
		params[:options] = "updated_at" if params[:options].blank?
		params[:sort] = "DESC" if params[:sort].blank?
		@all_deployments = Deployment.order("deployments.#{params[:options]} #{params[:sort]}").all
	end

	def show
		@deployment = Deployment.find(params[:id])
		get_question_mapper
	end

	def update
		deployment = Deployment.find(params[:id])
		return if current_user.id != deployment.reviewer_id
		deployment.update(status: params[:status],
		 	review_time: ((Time.current - Time.parse(params[:current_time])) / 1.minute).round)
		deployment.update(checklist_comment: params[:deployment][:checklist_comment].strip) if params[:status] == "Rejected"
		UserMailer.status_mail(deployment).deliver
		redirect_to deployment_url(:id => deployment.id)
	end

	def trigger_deployment
		deployment = Deployment.find(params[:id])
		return if current_user.id != deployment.user_id || deployment.status != "Approved"
		trigger_helper(deployment)
		unless params[:channel_name].blank?
			send_message_on_slack_channel(params[:channel_name], "Deploying #commit")
		end
		redirect_to get_gitlab_pipeline_trigger_link(deployment)
	end

	private

	def create_issue(params, deployment)
		get_jira_api_services(decrypt_access_token(@user.jira_token), @user.email)
		response = @jira_api_services.create_issue(params[:project_name] + " - " + params[:deployments][:title],
			"CHECKLIST LINK: " + Figaro.env.domain_base_url + "/deployments/" + deployment.id.to_s,
			User.find(deployment.reviewer_id).username)
		puts Figaro.env.jira_base_url + "/browse/" + response["key"]
		Figaro.env.jira_base_url + "browse/" + response["key"]
	end

	def trigger_helper(deployment)
		get_gitlab_api_services(decrypt_access_token(current_user.gitlab_token))
		@last_pipeline_id = @gitlab_api_services.get_last_pipeline_id_of_commit(deployment.commit_id, deployment.project_id)
		job_id = get_job_id_from_job_name(@gitlab_api_services.get_jobs_of_a_pipeline(deployment.project_id, @last_pipeline_id), deployment.job_name)
	end

	def params_valid?(params)
		return true if !User.where(:email => params[:deployments][:reviewer_email]).blank? && current_user.id.to_s == params[:user_id]
		redirect_to new_deployment_path(user_id: current_user.id,
			project_name: params[:project_name],
			commit_id: params[:commit_id],
			diff_link: params[:diff_link],
			last_deployed_commit: params[:last_deployed_commit],
			project_id: params[:project_id])
		return false
	end

	def get_job_id_from_job_name(jobs, job_name)
		jobs.each do |job|
			return job["id"] if job["name"] == job_name
		end
	end

	def get_details
		@user = current_user
		@last_deployed_commit = params[:last_deployed_commit]
		@project_id = params[:project_id]
	end


	def generate_diff_link(params)
		git_diff_link =  Figaro.env.diff_base_url +
		"/users/" + User.where(:email => params[:deployments][:reviewer_email]).first.id.to_s +
		"/projects/" + params[:project_id] +
		"/commits/" + params[:commit_id] +
		"?last_deployed_commit=" + params[:last_deployed_commit] +
		"&project_name=" + params[:project_name]
		git_diff_link
	end

	def get_gitlab_pipeline_trigger_link(deployment)
		pipeline_trigger_gitlab_link = Figaro.env.gitlab_base_url +
		@user.username + "/" +
		deployment.project_name +
		"/pipelines/" + @last_pipeline_id.to_s
	end

	def check_admin
		get_admins
		return if current_user.email == @admin
		redirect_to action: "index", controller: "projects", user_id: current_user.id.to_s
	end
end
