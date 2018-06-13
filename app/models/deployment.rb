class Deployment < ApplicationRecord
	validates :user_id, :project_name , :commit_id , presence: true
end
