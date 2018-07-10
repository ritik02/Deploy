require 'httparty'

desc "Populate Users database with seed data"
task populate_database: :environment do 
  token = ARGV[1].to_s
  response = get_users("1" , token)
  next_page = response.headers["X-Next-Page"]
  response.each do |user|
    User.create(gitlab_user_id: user["id"] , name: user["name"] , username: user["username"], email: user["username"] + "@go-jek.com")
  end
  while !next_page.blank? do
    page = next_page
    response = get_users(page , token)
    response.each do |user|
      User.create(gitlab_user_id: user["id"] , name: user["name"] , username: user["username"], email: user["username"] + "@go-jek.com")
    end
    next_page = response.headers["X-Next-Page"]
  end
  User.where(username: "akashs").first.update(admin: true)
end

def get_users(page="1" , token)
  url = "https://source.golabs.io/api/v4/users?private_token=" + token + "&active=true&per_page=100&page=" + page
  HTTParty.get(url)
end 