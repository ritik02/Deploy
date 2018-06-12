require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
	fixtures :deployments , :users
  describe "GET deployments#edit" do
    it "should open deployment edit page when checklist button is clicked" do
      VCR.use_cassette("user_deployment_checklist") do
        sign_in users(:four)
        get :edit, params: { id: deployments(:one).id}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
