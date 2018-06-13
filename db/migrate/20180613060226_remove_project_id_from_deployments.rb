class RemoveProjectIdFromDeployments < ActiveRecord::Migration[5.2]
  def change
    remove_column :deployments, :project_id, :integer
  end
end
