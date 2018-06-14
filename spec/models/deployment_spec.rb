require 'rails_helper'

RSpec.describe Deployment, type: :model do
	fixtures :deployments
  it "is not valid without a user_id" do
  	deploy = deployments(:one)
  	deploy.user_id = nil
  	expect(deploy).to_not be_valid
  end

  it "is not valid without a commit_id" do
  	deploy = deployments(:one)
  	deploy.commit_id = nil
  	expect(deploy).to_not be_valid
  end

  it "is not valid without a project_name" do
  	deploy = deployments(:one)
  	deploy.project_name = nil
  	expect(deploy).to_not be_valid
  end
end
