require 'rails_helper'
RSpec.describe GitlabApiServices  do
   include EncryptionHelper
   fixtures :users

   context "check api for valid token" do
      it "Should return TRUE when token is Valid'" do
         actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).check_api_for_valid_token?
         expect(actual).to eq true
      end

      it "Should return FALSE when token is Invalid'" do
         actual = GitlabApiServices.new(decrypt_access_token(users(:two).gitlab_token)).check_api_for_valid_token?
         expect(actual).to eq false
      end
   end

   context "check api for user details" do
      it "Should contain the name of the user'" do
         actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_user_details(users(:one).username)
         expect(actual.first["name"]).to eq "Ritik Verma"
      end
   end

   context "check api for number of pages" do
      it "Should return 1 when there are 2 projects" do
         actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_number_of_pages(users(:one).gitlab_user_id)
         expect(actual).to eq 1
      end
   end

   context "check api for project details" do
      it "Should return 2 projects" do
         actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_user_projects(users(:one).gitlab_user_id, 1)
         expect(actual.length).to eq 3
         expect(actual[0]["name"]).to eq "blank"
      end
   end

   context "check api for search project results" do
      it "Should return 'test2' project" do
         actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_search_results(users(:one).gitlab_user_id, "test2")
         expect(actual[0]["name"]).to eq "test2"
      end
   end


end
