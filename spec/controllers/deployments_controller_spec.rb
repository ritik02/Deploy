require  'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
	fixtures :deployments , :users
	describe "GET deployments#new" do
		it "should open deployment new page when checklist button is clicked" do
			VCR.use_cassette("deployment_new") do
				sign_in users(:eleven)
				get :new , params: {user_id: users(:eleven).id, project_name: "Calculator_Project", commit_id: "r3df32", project_id: 234, last_deployed_commit: "r3df32"}
				expect(response).to have_http_status(:success)
			end
		end

	end

	describe "GET deployments#index" do
		it "should open deployments index page (history of deployments) when admin" do
			sign_in users(:four)
			get :index, params: {options: "reviewer_id", sort: "DESC", :page => 1}
			expect(response).to have_http_status(:success)
			expect(assigns(:all_deployments)).to eq Deployment.order('deployments.reviewer_id DESC').all.paginate(:page => 1, :per_page => 20)
		end

		it "should redirect to projects index page when not admin" do
			sign_in users(:one)
			subject.current_user.email = "not_admin@go-jek.com"
			get :index, params: {options: "reviewer_id", sort: "DESC"}
			expect(response).to redirect_to user_projects_path(user_id: users(:one).id)
		end
	end

	describe "GET deployments#create" do
		it "should create the checklist of a deployment" do
			VCR.use_cassette("deployment_create") do
				sign_in users(:eleven)
				post :create, params: {status: "Checklist Filled", deployments: {title: "TestTitle"},reviewer_email: "ritik.v.aux@go-jek.com", user_id: users(:eleven).id, project_name: "New Project", commit_id: "abc3423", reviewer_id: 5, project_id: 3852, last_deployed_commit: "abc1232"}
				expect(Deployment.fifth.status).to eq "Pending Approval"
				expect(Deployment.fifth.jira_link).not_to be nil
			end
		end

		it "should not create the checklist of a deployment if reviewer_email is invalid" do
			sign_in users(:four)
			post :create, params: {status: "Checklist Filled",deployments: {title: "TestTitle"}, reviewer_email: "invalid@go-jek.com", user_id: users(:nine).id, project_name: "New Project", commit_id: "abc3423", reviewer_id: 5}
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
			put :update, params: {id: 1, status: "Approved", current_time: Time.current}
			expect(deployments(:one).status).to eq "Approved"
		end

		it "should update deployment status to Rejected when Rejected button is clicked when reviewer is valid" do
			sign_in users(:seven)
			put :update, params: {id: 1,status: "Rejected", current_time: Time.current, deployment: {checklist_comment: "COMMENT"} }
			expect(deployments(:one).status).to eq "Rejected"
			expect(deployments(:one).checklist_comment).to eq "COMMENT"
		end

		it "should not update deployment status to Rejected when Rejected button is clicked when reviewer is invalid" do
			sign_in users(:eight)
			put :update, params: {id: 1,status: "Rejected", current_time: Time.current, checklist_comment: "COMMENT"}
			expect(deployments(:one).status).to eq "Created"
		end

		it "should update review time to difference between page open and button clicked when reviewer is valid" do
			sign_in users(:ten)
			put :update, params: {id: 3, status: "Approved", current_time: Time.current}
			expect(deployments(:three).review_time).not_to be nil
		end
	end

	describe "GET deployments#trigger_deployment" do
		it "should redirect to users show page even if channel_name is not provided" do
			VCR.use_cassette("trigger_deployment_controller") do
				sign_in users(:ten)
				get :trigger_deployment, params: {id: 3, team_email: "group_mail@go-jek.com"}
				expect(response).to redirect_to user_url(id: users(:ten).id)
			end
		end

		it "should redirect to users show page if channel_name is provided" do
			VCR.use_cassette("trigger_deployment_with_channel_name") do
				sign_in users(:twelve)
				get :trigger_deployment, params: {id: 4, channel_name: "test_new", team_email: "group_mail@go-jek.com"}
				expect(response).to redirect_to user_url(id: users(:twelve).id)
			end
		end
	end

end
