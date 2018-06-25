require 'httparty'
require "base64"
class JiraApiServices
  def initialize(jira_token, user_email)
    @access_token = Base64.encode64(user_email + ":" + jira_token)
    @base_url = Figaro.env.jira_base_url + "rest/api/2"
    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Basic " + @access_token.sub("\n","")
    }
  end

  def check_api_for_valid_token?
    response = HTTParty.get(@base_url, :headers => @headers)
    puts response
    return false if response.code == 401
    return true
  end

  def create_issue(summary, description, reviewer)
    url = @base_url + "/issue"
    generate_body(summary, description, reviewer)
    response = HTTParty.post(url, :body => @body.to_json, :headers => @headers)
    response
  end

  private
  def generate_body(summary, description, reviewer)
    @body = {
      "fields" => {
        "project" => {
          "key" => Figaro.env.jira_project_key
        },
        "summary" => summary,
        "description" => description,
        "issuetype" => {
          "name" => Figaro.env.jira_issue_type
        },
        "assignee" => {
          "name" => reviewer
        }
      }
    }
  end

end
