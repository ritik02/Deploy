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
    	get :new , params: {user_id: 4, project_id: 3850, commit_id: "r3df32"}
      expect(Deployment.all.length).to eq(previous_length+1)
    end
  end

  describe "GET deployments#create" do
    it "should create the checklist of a deployment" do
      sign_in users(:four)
      post :create, params: {deployments: {title: "TestTitle"}, deployment_id: 1}
      expect(deployments(:one).status).to eq "filled"
    end
  end
end
