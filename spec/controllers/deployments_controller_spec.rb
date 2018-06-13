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
    	get :new
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
end
