require 'rails_helper'
RSpec.describe GitlabApiServices  do
  include EncryptionHelper
  fixtures :users

  context "check api for valid token" do
    it "Should return TRUE when token is Valid'" do
      VCR.use_cassette("valid_gitlab_token") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).check_api_for_valid_token?
        expect(actual).to eq true
      end
    end

    it "Should return FALSE when token is Invalid'" do
      VCR.use_cassette("invalid_gitlab_token") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:two).gitlab_token)).check_api_for_valid_token?
        expect(actual).to eq false
      end
    end
  end

  context "check api for user details" do
    it "Should contain the name of the user'" do
      VCR.use_cassette("user_details") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_user_details(users(:one).username)
        expect(actual.first["name"]).to eq "Ritik Verma"
      end
    end
  end


  context "check api for project details" do
    it "Should return 2 projects" do
      VCR.use_cassette("paginated_projects") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_user_projects(users(:one).gitlab_user_id, 1)
        expect(actual.length).to eq 3
        expect(actual[0]["name"]).to eq "blank"
      end
    end
  end

  context "check api for search project results" do
    it "Should return 'test2' project" do
      VCR.use_cassette("projects") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_search_results(users(:one).gitlab_user_id, "test2")
        expect(actual[0]["name"]).to eq "test2"
      end
    end
  end

  context "check api for project details" do
    it "Should return project details" do
      VCR.use_cassette("project_details") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:four).gitlab_token)).get_project_details(3892)
        expect(actual["name"]).to eq "blank"
      end
    end
  end

  context "check api for jobs of a project" do
    it "Should return jobs of project" do
      VCR.use_cassette("project_jobs_details") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:one).gitlab_token)).get_project_jobs(3850)
        expect(actual[0]["commit"]["message"]).to eq "Update README.md"
      end
    end
  end

  context "check api for last deployed commit of project" do
    it "Should return last deployed commit of project" do
      VCR.use_cassette("project_last_deployed_commit") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:four).gitlab_token)).get_last_deployed_commit(3850)
        expect(actual["deployable"]["name"]).to eq "deploy_staging"
      end
    end
  end


  context "check api for all commits after last deployed commit of project" do
    it "Should return all commits after last deployed commit of project" do
      VCR.use_cassette("project_all_commits_after_last_deployed_commit") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:four).gitlab_token)).get_all_commits_after_last_deployed_commit(3850, "2018-06-13T06:18:35Z")
        expect(actual[0]["short_id"]).to eq "ed62398d"
      end
    end
  end

  context "check api for diff of last_deployed and selected_commit" do
    it "Should return diff of last_deployed and selected_commit" do
      VCR.use_cassette("project_commit_diff_of_last_deployed_commit") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:six).gitlab_token)).get_diff_of_two_commits(3853, "2a0b1a6d", "e5487430")
        expect(actual[0]["new_path"]).to eq ".gitlab-ci.yml"
      end
    end
  end

  context "check api for project pipelines" do
    it "Should return pipelines of selected project" do
      VCR.use_cassette("project_pipelines") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:four).gitlab_token)).get_project_pipelines(3850)
        expect(actual[0]["id"]).to eq 213350
      end
    end

    it "Should return 5 or less pipelines of selected project" do
      VCR.use_cassette("project_pipelines") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:four).gitlab_token)).get_project_pipelines(3850)
        expect(actual.length).to be <= 5
      end
    end
  end

context "check api for jobs of pipelines" do
    it "Should return jobs for a pipeline" do
      VCR.use_cassette("project_pipeline_jobs") do
        actual = GitlabApiServices.new(decrypt_access_token(users(:four).gitlab_token)).get_jobs_of_a_pipeline(3850, 210972)
        expect(actual[0]["id"]).to eq 1328119
      end
    end
  end

  context "check api for all deployments" do
    it "Should return deployments of a project" do
      VCR.use_cassette("all_deployed_commits") do
        actual = GitlabApiServices.new("ZUToPioeFWK5nvSWMLAi").get_all_deployments(389)
        expect(actual[0]["deployable"]["name"]).to eq "staging_deploy"
      end
    end
  end

end
