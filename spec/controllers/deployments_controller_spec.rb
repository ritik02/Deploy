require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
	fixtures :deployments , :users
  describe "GET deployments#new" do
    it "should open deployment new page when checklist button is clicked" do
      sign_in users(:four)
      get :new , params: {user_id: 4, project_name: "Calculator_Project", commit_id: "r3df32", project_id: 234, last_deployed_commit: "r3df32"}
      expect(response).to have_http_status(:success)
    end

  end

	describe "GET deployments#index" do
		it "should open deployments index page (history of deployments) when deployments button is clicked" do
			sign_in users(:four)
      get :index
      expect(response).to have_http_status(:success)
		end
	end

  describe "GET deployments#create" do
    it "should create the checklist of a deployment" do
			sign_in users(:nine)
      post :create, params: {status: "Checklist Filled",deployments: {title: "TestTitle", reviewer_email: "ritik.v.aux@go-jek.com"}, user_id: users(:nine).id, project_name: "New Project", commit_id: "abc3423", reviewer_id: 5}
			expect(Deployment.second.status).to eq "Pending Approval"
    end

		it "should not update the checklist of a deployment if reviewer_email is invalid" do
			sign_in users(:four)
      post :create, params: {status: "Checklist Filled",deployments: {title: "TestTitle", reviewer_email: "invalid@go-jek.com"}, user_id: users(:nine).id, project_name: "New Project", commit_id: "abc3423", reviewer_id: 5}
      expect(deployments(:one).status).to eq "Created"
			expect(response).to render_template('deployments/new')
    end
  end

	describe "GET deployments#show" do
    it "should open show deployment page if reviewer is authorized" do
      sign_in users(:seven)
      get :show, params: {id: 1}
			expect(response).to render_template('deployments/show')
			expect(response).to have_http_status(:success)
    end
  end

		describe "GET deployments#destroy" do
    it "should update deployment status to Approved when Approve button is clicked when reviewer is valid" do
      sign_in users(:seven)
      put :update, params: {id: 1, status: "Approved"}
			expect(deployments(:one).status).to eq "Approved"
    end

		it "should update deployment status to Rejected when Rejected button is clicked when reviewer is valid" do
      sign_in users(:seven)
      put :update, params: {id: 1,status: "Rejected"}
			expect(deployments(:one).status).to eq "Rejected"
    end

		it "should not update deployment status to Rejected when Rejected button is clicked when reviewer is invalid" do
      sign_in users(:eight)
      put :update, params: {id: 1,status: "Rejected"}
			expect(deployments(:one).status).to eq "Created"
    end
  end
end
