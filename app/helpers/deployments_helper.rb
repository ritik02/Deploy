module DeploymentsHelper
	def generate_user_specific_diff_link(diff_link, user_id)
		Figaro.env.diff_base_url +
		("/users/") + user_id.to_s + diff_link[diff_link.index("/projects/")...diff_link.length]
	end

	def get_gitlab_pipeline_trigger_link(deployment)
		get_gitlab_api_services(decrypt_access_token(@user.gitlab_token))
		last_pipeline_id = @gitlab_api_services.get_last_pipeline_id_of_commit(deployment.commit_id, deployment.project_id)
		job_id = get_job_id_from_job_name(@gitlab_api_services.get_jobs_of_a_pipeline(deployment.project_id, last_pipeline_id), deployment.job_name)
		pipeline_trigger_gitlab_link = Figaro.env.gitlab_base_url +
		@user.username + "/" +
		deployment.project_name +
		"/pipelines/" + last_pipeline_id.to_s
	end

	def get_job_id_from_job_name(jobs, job_name)
		jobs.each do |job|
			return job["id"] if job["name"] == job_name
		end
	end

end
