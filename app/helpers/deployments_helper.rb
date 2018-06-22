module DeploymentsHelper
	def generate_user_specific_diff_link(diff_link, user_id)
		diff_link[0..diff_link.index("users/")+5] + user_id.to_s + diff_link[diff_link.index("/projects/")...diff_link.length]
	end
end