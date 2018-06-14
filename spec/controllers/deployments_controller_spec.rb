require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
	fixtures :deployments , :users
  describe "GET deployments#new" do
    it "should open deployment new page when checklist button is clicked" do
      sign_in users(:four)
      get :new , params: {user_id: 4, project_name: "Calculator_Project", commit_id: "r3df32", project_id: 234, last_deployed_commit: "r3df32"}
      expect(response).to have_http_status(:success)
    end

    it "should create a new deployment" do
    	sign_in users(:four)
    	previous_length = Deployment.all.length
    	get :new , params: {user_id: 4, project_name: "Calculator_Project", commit_id: "r3df32", project_id: 234, last_deployed_commit: "r3df32"}
      expect(Deployment.all.length).to eq(previous_length+1)
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
			sign_in users(:four)
      post :create, params: {deployments: {title: "TestTitle", reviewer_email: "ritik.v.aux@go-jek.com"}, deployment_id: 1}
      expect(deployments(:one).status).to eq "Checklist Filled"
    end

		it "should not update the checklist of a deployment if reviewer_email is invalid" do
			sign_in users(:four)
      post :create, params: {deployments: {title: "TestTitle", reviewer_email: "invalid@go-jek.com"}, deployment_id: 1}
      expect(deployments(:one).status).to eq "Created"
			expect(response).to render_template('layouts/error')
    end
  end

	describe "GET deployments#destroy" do
    it "should delete deployment when delete button is clicked" do
      sign_in users(:four)
      delete :destroy, params: {id: 1}
			expect(Deployment.count).to eq 0
    end
  end

	describe "GET deployments#show" do
    it "should open show deployment page if reviewer is authorized" do
      sign_in users(:seven)
      get :show, params: {id: 1}
			expect(response).to render_template('deployments/show')
			expect(response).to have_http_status(:success)
    end

		it "should render error page if reviewer is not authorized to see this" do
      sign_in users(:four)
      get :show, params: {id: 1}
			expect(response).to render_template('layouts/error')
    end
  end
end
