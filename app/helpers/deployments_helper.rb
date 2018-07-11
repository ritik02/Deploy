module DeploymentsHelper
	def generate_user_specific_diff_link(diff_link, user_id)
		Figaro.env.diff_base_url +
		("/users/") + user_id.to_s + diff_link[diff_link.index("/projects/")...diff_link.length]
	end

	def get_gitlab_pipeline_trigger_link(deployment)
		get_gitlab_api_services(decrypt_access_token(@user.gitlab_token))
		last_pipeline_id = @gitlab_api_services.get_last_pipeline_id_of_commit(deployment.commit_id, deployment.project_id)
		project_web_url = @gitlab_api_services.get_project_details(deployment.project_id)
		puts project_web_url
		puts project_web_url["web_url"]
		
		pipeline_trigger_gitlab_link = project_web_url["web_url"] +
		"/pipelines/" + last_pipeline_id.to_s
	end

	def get_job_id_from_job_name(jobs, job_name)
		jobs.each do |job|
			return job["id"] if job["name"] == job_name
		end
	end

end
