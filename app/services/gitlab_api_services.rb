require 'httparty'
class GitlabApiServices
	def initialize(gitlab_token)
		@access_token = gitlab_token
		@base_url = "https://source.golabs.io/api/v4"
	end

	def get_user_details(username)
    url = @base_url + "/users?private_token=" + @access_token + "&username=" + username
    HTTParty.get(url)
	end

	def get_number_of_pages(gitlab_userid)
    url = @base_url + "/users/" + gitlab_userid.to_s + "/projects?private_token=" + @access_token
    response = HTTParty.get(url)
    projects = response
    number_of_projects = projects.length
    number_of_pages = number_of_projects / 10
    if number_of_projects % 10 != 0
      number_of_pages = number_of_pages + 1
    end
    return number_of_pages
  end

  def get_user_projects(gitlab_userid, page_id)
    url = @base_url + "/users/" + gitlab_userid.to_s + "/projects?private_token=" + @access_token + "&per_page=1&page=" + page_id.to_s
    HTTParty.get(url)
  end


end
