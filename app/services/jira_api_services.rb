require 'httparty'
require "base64"
class JiraApiServices
  def initialize(jira_token, user_email)
    @access_token = Base64.encode64(user_email + ":" + jira_token)
    @base_url = "https://godeploy.atlassian.net/rest/api/2"
    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Basic " + @access_token.sub("\n","")
    }
  end

  def check_api_for_valid_token?
    response = HTTParty.get(@base_url, :headers => @headers)
    return false if response.code == 401
    return true
    end

end
