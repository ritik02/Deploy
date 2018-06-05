require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	fixtures :users

	describe "GET users#home" do
		it "should redirect signed in user to the home page for updating token" do
			sign_in users(:one)
			get :home
			expect(assigns(:user)).to eq(users(:one))
		end

		it "should show projects page if gitlab token is valid" do
			sign_in users(:one)
			form_params = {
											user: {
												gitlab_token: decrypt_access_token(users(:one).gitlab_token)
											}
 									 }
  		patch :update, params: form_params
  		expect(response).to redirect_to(users_project_url)
		end

		it "should reload home page if gitlab token is invalid" do
			sign_in users(:one)
			form_params = {
											user: {
												gitlab_token: "invalid_gitlab_token"
											}
 									 }
  		patch :update, params: form_params
  		expect(response).to redirect_to(users_home_url)
		end
	end

	describe "PATCH users#update" do
		it "should update gitlab token for a user if valid" do
			sign_in users(:three)
			expected_token = decrypt_access_token(users(:one).gitlab_token)
			form_params = {
											user: {
												gitlab_token: decrypt_access_token(users(:one).gitlab_token)
											}
 									 }
  		patch :update, params: form_params
  		actual_token = decrypt_access_token(subject.current_user.gitlab_token)
  		expect(actual_token).to eq(expected_token)
		end

		it "should not update gitlab token for a user if invalid" do
			new_user = users(:three)
			sign_in new_user
			expected_token = users(:one).gitlab_token
			form_params = {
											user: {
												gitlab_token: "invalid_gitlab_token"
											}
 									 }
  		patch :update, params: form_params
  		expect(new_user.gitlab_token).to eq(nil)
		end
	end

	describe "GET users#project" do
		it "should return selected projects according to the search query of user" do
			sign_in users(:one)
			get :project, params: {:search_query => "test2"}
			expect(assigns(:projects).length).to eq(1)
		end

		it "should redirect to homepage if users gitlab token is expired" do
			sign_in users(:two)
			get :project
			expect(response).to redirect_to(users_home_url)
		end

		it "should return projects of user when no search query" do
			sign_in users(:one)
			projects_of_user_one = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_user_projects(users(:one).gitlab_userid, 1)
			get :project, params: {:search_query => ""}
			expect(assigns(:projects).length).to eq(projects_of_user_one.length)
		end
	end
end
