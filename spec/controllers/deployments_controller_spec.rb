require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
	fixtures :deployments , :users
  describe "GET deployments#new" do
    it "should open deployment new page when checklist button is clicked" do
      sign_in users(:four)
      get :new
      expect(response).to have_http_status(:success)
    end

    it "should create a new deployment" do
    	sign_in users(:four)
    	previous_length = Deployment.all.length
    	get :new , params: {user_id: 4, project_name: "Calculator_Project", commit_id: "r3df32"}
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
      expect(deployments(:one).status).to eq "filled"
    end

		it "should not update the checklist of a deployment if reviewer_email is invalid" do
			sign_in users(:four)
      post :create, params: {deployments: {title: "TestTitle", reviewer_email: "invalid@go-jek.com"}, deployment_id: 1}
      expect(deployments(:one).status).to eq "created"
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

end
