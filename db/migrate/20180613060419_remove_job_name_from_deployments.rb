class RemoveJobNameFromDeployments < ActiveRecord::Migration[5.2]
  def change
    remove_column :deployments, :job_name, :string
  end
end
