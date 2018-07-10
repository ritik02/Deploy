require 'httparty'

desc "Populate Users database with seed data"
task populate_database: :environment do
  response = get_users()
  next_page = response.headers["X-Next-Page"]
  response.each do |user|
    User.create(gitlab_user_id: user["id"] , name: user["name"] , username: user["username"] , email: user["username"] + "@go-jek.com")
  end
  while !next_page.blank? do
    page = next_page
    response = get_users(page)
    response.each do |user|
      User.create(gitlab_user_id: user["id"] , name: user["name"] , username: user["username"] , email: user["username"] + "@go-jek.com")
    end
    next_page = response.headers["X-Next-Page"]
  end
  User.where(username: "akashs").first.update(admin: true)
end

def get_users(page="1")
  url = "https://source.golabs.io/api/v4/users?private_token=ZqMeN2FoAbuudMSv85JL&active=true&per_page=100&page=" + page
  HTTParty.get(url)
end

