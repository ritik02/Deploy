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
      VCR.use_cassette("invalid_gitlab_token") do
        sign_in users(:two)
        get :index, params: { user_id: users(:two).id }
        expect(response).to redirect_to(action: "edit", controller: "users", id: users(:two).id)
      end
    end

    it "should return selected projects according to the search query of user" do
      VCR.use_cassette("searched_projects") do
        sign_in users(:one)
        get :index, params: { user_id: users(:one).id, :search_query => "test2" }
        expect(assigns(:projects).length).to eq(1)
      end
    end

    it "should return projects of user when no search query" do
      VCR.use_cassette("paginated_projects") do
        sign_in users(:one)
        get :index, params: { user_id: users(:one).id, :search_query => "" }
        expect(assigns(:projects).length).to eq(3)
      end
    end
  end

  describe "GET projects#show" do
    it "should open user_project page when a project is clicked" do
      sign_in users(:one)
      get :show, params: { user_id: users(:one).id, id: 3892 }
      expect(response).to have_http_status(:success)
    end
  end
end
