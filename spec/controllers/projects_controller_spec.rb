require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  fixtures :users
  describe "GET projects#index" do
    it "should redirect to edit_users page if token is nil for new user" do
      sign_in users(:three)
      get :index, params: { user_id: users(:three).id }
      expect(response).to redirect_to(action: "edit", controller: "users", id: users(:three).id)
    end

    it "should redirect to project index page even when user_id is invalid" do
      sign_in users(:eight)
      get :index, params: { user_id: "abcd" }
      expect(response).to redirect_to(action: "index", controller: "projects", user_id: users(:eight).id)
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
      VCR.use_cassette("user_project_details") do
        sign_in users(:four)
        get :show, params: { user_id: users(:four).id, id: 3850 }
        expect(response).to have_http_status(:success)
      end
    end

    it "should give stages_hash of pipelines" do
      VCR.use_cassette("stages_pipelines") do
        sign_in users(:four)
        get :show, params: { user_id: users(:four).id, id: 3850 }
        expect(assigns(:stages)["test"].first["name"]).to eq("rspec")
      end
    end

    it "should redirect to layouts/error when project_id is invalid" do
      VCR.use_cassette("user_project_id_invalid") do
        sign_in users(:eight)
        get :show, params: { user_id: users(:eight).id, id: "abcd" }
        expect(response).to render_template('layouts/error')
      end
    end

    it "should redirect to layouts/error when no pipelines exist for a project" do
      VCR.use_cassette("user_project_no_pipelines") do
        sign_in users(:nine)
        get :show, params: { user_id: users(:nine).id, id: 3852 }
        expect(response).to render_template('layouts/error')
      end
    end
  end

end
