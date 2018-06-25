module DeploymentsHelper
	def generate_user_specific_diff_link(diff_link, user_id)
		Figaro.env.diff_base_url + 
		("/users/") + user_id.to_s + diff_link[diff_link.index("/projects/")...diff_link.length]
	end
end