module UsersHelper

  def check_api_for_valid_token? token
    url = "https://source.golabs.io/api/v4/users?private_token=" + token
    response = HTTParty.get(url)
    if response.code == 200
      return true
    else false
    end
  end

end
