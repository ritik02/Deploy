require 'rails_helper'

RSpec.describe CommitsController, type: :controller do
  fixtures :users
  describe "GET commits#index" do
    it "should open user_project_commits page when a job button is clicked" do
      VCR.use_cassette("user_project_commit_details") do
        sign_in users(:eight)
        get :index, params: { user_id: users(:eight).id, project_id: 3850 , job_name: "prod" }
        expect(response).to have_http_status(:success)
      end
    end

     it "should render error template if no deployment related to job name is found" do
      VCR.use_cassette("user_project_commit_details") do
        sign_in users(:eight)
        get :index, params: { user_id: users(:eight).id, project_id: 3850 , job_name: "somename" }
        expect(response).to render_template('layouts/error')
      end
    end

    it "should render error template if project does not contain any deployments" do
      VCR.use_cassette("user_project_no_deployments_found") do
        sign_in users(:nine)
        puts "HELOEHELEOEOEOEOEO\n"
        get :index, params: { user_id: users(:nine).id, project_id: 3852 , job_name: "prod" }
        expect(response).to render_template('layouts/error')
      end
    end

    it "should render open commit index if last deployed commit related to job name is found" do
      VCR.use_cassette("user_project_last_deployed_commit_found") do
        sign_in users(:ten)
        get :index, params: { user_id: users(:ten).id, project_id: 3850 , job_name: "abcd" }
        puts response
        expect(response).to have_http_status(:success)
      end
    end

    it "should render error template if user is not authorized to view deployments" do
      VCR.use_cassette("unauthorized_to_view_deployments") do
        sign_in users(:nine)
        get :index, params: { user_id: users(:nine).id, project_id: 394 , job_name: "prod_deploy" }
        expect(response).to render_template('layouts/error')
      end
    end
  end

  describe "GET commits#show" do
    it "should open user_project_commits page when a commit is clicked" do
      VCR.use_cassette("user_project_commit_diff") do
        sign_in users(:eight)
        get :show, params: { user_id: users(:eight).id, project_id: 3850, id: "56fe362d", last_deployed_commit: "56fe362d" }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
