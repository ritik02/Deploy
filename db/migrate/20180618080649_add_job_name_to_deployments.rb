class AddJobNameToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :job_name, :string
  end
end
