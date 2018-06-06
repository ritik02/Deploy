require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  fixtures :users
  describe "GET projects#index" do
    it "should redirect to edit_users page if token is nil for new user" do
      sign_in users(:three)
      get :index, params: { user_id: users(:three).id }
      expect(response).to redirect_to(action: "edit", controller: "users", id: users(:three).id)
    end

    it "should redirect to edit page if users gitlab token is expired" do
      sign_in users(:two)
      get :index, params: { user_id: users(:two).id }
      expect(response).to redirect_to(action: "edit", controller: "users", id: users(:two).id)
    end

    it "should return selected projects according to the search query of user" do
      sign_in users(:one)
      get :index, params: { user_id: users(:one).id, :search_query => "test2" }
      expect(assigns(:projects).length).to eq(1)
    end

    it "should return projects of user when no search query" do
      VCR.use_cassette("projects") do
        projects_of_user_one = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_user_projects(users(:one).gitlab_user_id, 1)
        get :index, params: { user_id: users(:one).id, :search_query => "" }
        expect(assigns(:projects).length).to eq(projects_of_user_one.length)
      end
    end
  end
end
