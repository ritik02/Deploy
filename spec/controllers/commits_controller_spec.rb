require 'rails_helper'

RSpec.describe CommitsController, type: :controller do
  fixtures :users
  describe "GET commits#index" do
    it "should open user_project_commits page when a product deployment button is clicked" do
      VCR.use_cassette("user_project_commit_details") do
        sign_in users(:four)
        get :index, params: { user_id: users(:four).id, project_id: 3850 }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET commits#show" do
    it "should open user_project_commits page when a commit is clicked" do
      VCR.use_cassette("user_project_commit_diff") do
        sign_in users(:four)
        get :show, params: { user_id: users(:four).id, project_id: 3850, id: "56fe362d" }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
