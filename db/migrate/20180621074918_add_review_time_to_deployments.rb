class AddReviewTimeToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :review_time, :integer
  end
end
