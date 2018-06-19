require  'rails_helper'

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
			post :create, params: {status: "Checklist Filled", deployments: {title: "TestTitle", reviewer_email: "ritik.v.aux@go-jek.com"}, user_id: users(:nine).id, project_name: "New Project", commit_id: "abc3423", reviewer_id: 5, project_id: 3852, last_deployed_commit: "abc1232"}
			expect(Deployment.fourth.status).to eq "Pending Approval"
		end

		it "should not create the checklist of a deployment if reviewer_email is invalid" do
			sign_in users(:four)
			post :create, params: {status: "Checklist Filled",deployments: {title: "TestTitle", reviewer_email: "invalid@go-jek.com"}, user_id: users(:nine).id, project_name: "New Project", commit_id: "abc3423", reviewer_id: 5}
			expect(deployments(:one).status).to eq "Created"
			response.should redirect_to '/deployments/new?commit_id=abc3423&project_name=New+Project&user_id='+subject.current_user.id.to_s
		end
	end

	describe "GET deployments#show" do
		it "should open show deployment page" do
			sign_in users(:seven)
			get :show, params: {id: 1}
			expect(response).to render_template('deployments/show')
			expect(response).to have_http_status(:success)
		end
	end

	describe "GET deployments#update" do
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

	describe "GET deployments#trigger_deployment" do
		it "should trigger job play when deploy button is clicked" do
			VCR.use_cassette("trigger_deployment_controller") do
				sign_in users(:ten)
				post :trigger_deployment, params: {id: 2}
				expect(Deployment.find(2).status).to eq "Deployed"
				expect(response).to redirect_to job_trace_path(id: 1354965, project_id: 3850)
			end
		end

		it "should trigger job retry when deploy button is clicked" do
			VCR.use_cassette("trigger_deployment_controller_retry") do
				sign_in users(:ten)
				post :trigger_deployment, params: {id: 3}
				expect(response).to redirect_to job_trace_path(id: 1354965, project_id: 3850)
			end
		end
	end

	describe "GET deployments#job_trace" do
		it "should open job_trace page when deployment is triggered" do
			VCR.use_cassette("job_trace_controller") do
				sign_in users(:ten)
				get :job_trace, params: {id: 135457, project_id: 3850}
				expect(response).to have_http_status(:success)
			end
		end
	end
end
