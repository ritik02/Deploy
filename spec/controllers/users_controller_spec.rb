require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	fixtures :users
	before(:each) do
		@valid_token = users(:one).gitlab_token
	end

	describe "GET users#edit" do
		it "should redirect signed in user to the edit(home) page for updating token" do
			sign_in users(:one)
			get :edit, params: { :id => users(:one).id}
			expect(assigns(:user)).to eq(users(:one))
		end
	end

	describe "PATCH users#update" do
		it "should update gitlab token for a user if valid" do
			VCR.use_cassette("valid_gitlab_token") do
				sign_in users(:three)
				expected_token = decrypt_access_token(@valid_token)
				form_params = {
					id: users(:three).id,
					user: { gitlab_token: decrypt_access_token(@valid_token) }
				}
				patch :update, params: form_params
				actual_token = decrypt_access_token(subject.current_user.gitlab_token)
				expect(actual_token).to eq(expected_token)
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

		it "should show projects page if gitlab token is valid" do
			VCR.use_cassette("valid_gitlab_token") do
				sign_in users(:one)
				form_params = {
					id: users(:one).id,
					user: { gitlab_token: decrypt_access_token(@valid_token) }
				}
				patch :update, params: form_params
				expect(response).to redirect_to(action: "index", controller: "projects", user_id: users(:one).id)
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
				user: { gitlab_token: "" }
			}
			patch :update, params: form_params
			expect(response).to redirect_to(edit_user_url)
		end
	end

	describe "GET users#index" do
		it "should open signed in user to the index users page" do
			sign_in users(:one)
			get :index
			expect(response).to have_http_status(:success)
			expect(assigns(:users)).to eq User.all
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
end
