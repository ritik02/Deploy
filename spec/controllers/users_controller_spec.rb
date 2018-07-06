require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	fixtures :users
	describe "GET users#edit" do
		it "should redirect signed in user to the edit(home) page for updating token" do
			sign_in users(:one)
			get :edit, params: { :id => users(:one).id}
			expect(assigns(:user)).to eq(users(:one))
		end
	end

	describe "PATCH users#update" do
		it "should update both gitlab and jira token for a user if valid" do
			VCR.use_cassette("valid_tokens") do
				sign_in users(:eleven)
				expected_token = decrypt_access_token(users(:eleven).gitlab_token)
				form_params = {
					id: users(:eleven).id,
					user: { gitlab_token: decrypt_access_token(users(:eleven).gitlab_token),
					 				jira_token: decrypt_access_token(users(:eleven).jira_token)}
				}
				patch :update, params: form_params
				actual_gitlab_token = decrypt_access_token(subject.current_user.gitlab_token)
				actual_jira_token = decrypt_access_token(subject.current_user.jira_token)
				expect(actual_gitlab_token).to eq(expected_token)
				expect(actual_jira_token).to eq(decrypt_access_token(users(:eleven).jira_token))
			end
		end

		it "should not update gitlab token for a user if invalid" do
			VCR.use_cassette("new_invalid_gitlab_token") do
				sign_in users(:three)
				form_params = {
					id: users(:three).id,
					user: { gitlab_token: "invalid_gitlab_token" }
				}
				patch :update, params: form_params
				expect(users(:three).gitlab_token).to eq(nil)
			end
		end

		it "should not update gitlab token for a user if blank" do
			sign_in users(:three)
			form_params = {
				id: users(:three).id,
				user: { gitlab_token: "" }
			}
			patch :update, params: form_params
			expect(users(:three).gitlab_token).to eq(nil)
		end

		it "should show projects page if both tokens is valid" do
			VCR.use_cassette("valid_tokens") do
				sign_in users(:eleven)
				form_params = {
					id: users(:eleven).id,
					user: { gitlab_token: decrypt_access_token(users(:eleven).gitlab_token),
					 				jira_token: decrypt_access_token(users(:eleven).jira_token)}
				}
				patch :update, params: form_params
				expect(response).to redirect_to(action: "index", controller: "projects", user_id: users(:eleven).id)
			end
		end

		it "should reload edit page if gitlab token is invalid" do
			VCR.use_cassette("new_invalid_gitlab_token") do
				sign_in users(:two)
				form_params = {
					id: users(:two).id,
					user: { gitlab_token: "invalid_gitlab_token" }
				}
				patch :update, params: form_params
				expect(response).to redirect_to(edit_user_url)
			end
		end

		it "should reload edit page if gitlab token is empty" do
			sign_in users(:three)
			form_params = {
				id: users(:three).id,
				user: { gitlab_token: "",
				 				jira_token: decrypt_access_token(users(:eleven).jira_token)}
			}
			patch :update, params: form_params
			expect(response).to redirect_to(edit_user_url)
		end

		it "should reload edit page if jira token is invalid" do
			VCR.use_cassette("new_invalid_jira_token") do
				sign_in users(:eleven)
				form_params = {
					id: users(:eleven).id,
					user: { gitlab_token: decrypt_access_token(users(:eleven).gitlab_token),
					 				jira_token: "invalid_token"}
				}
				patch :update, params: form_params
				expect(response).to redirect_to(edit_user_url)
			end
		end

		it "should reload edit page if jira token is empty" do
			VCR.use_cassette("new_empty_jira_token") do
				sign_in users(:eleven)
				form_params = {
					id: users(:eleven).id,
					user: { gitlab_token: decrypt_access_token(users(:eleven).gitlab_token),
									jira_token: ""}
								}
				patch :update, params: form_params
				expect(response).to redirect_to(edit_user_url)
			end
		end
	end

	describe "GET users#index" do
		it "should open signed in user to the index users page when admin" do
			sign_in users(:ten)
			get :index, params: {:page => 1}
			expect(response).to have_http_status(:success)
			expect(assigns(:users)).to eq User.all.order('users.updated_at DESC').paginate(:page => 1, :per_page => 20)
		end

		it "should redirect to projects page of signed in user when not admin" do
			sign_in users(:one)
			subject.current_user.email = "not_admin@go-jek.com"
			get :index
			expect(response).to redirect_to user_projects_path(user_id: users(:one).id)
		end
	end

	describe "GET users#show" do
		it "should open signed in user to the show user page" do
			sign_in users(:one)
			get :show, params: {id: users(:one).id}
			expect(response).to have_http_status(:success)
			expect(assigns(:user)).to eq User.find(users(:one).id)
		end
	end

	describe "GET users#make_admin" do
		it "should grant admin privleges to the user" do
			sign_in users(:twelve)
			not_admin_user_id = users(:six).id
			get :make_admin, params: {id: not_admin_user_id}
			expect(User.find(not_admin_user_id).admin).to eq true
			expect(response).to redirect_to users_path
		end
	end
end
