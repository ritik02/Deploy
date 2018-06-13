class AddProjectNameToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :project_name, :string
  end
end
