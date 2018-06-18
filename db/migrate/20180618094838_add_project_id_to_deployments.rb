class AddProjectIdToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :project_id, :integer
  end
end
