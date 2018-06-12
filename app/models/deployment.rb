class Deployment < ApplicationRecord
	validates :user_id, :project_id , :commit_id , presence: true  
end
