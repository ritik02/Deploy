require 'rails_helper'

RSpec.describe User, type: :model do
	it "is valid with valid username" do
		expect(User.new({username: "Testusername"})).to be_valid
	end
  it "is not valid without a username" do
  	expect(User.new).to_not be_valid
  end
end
