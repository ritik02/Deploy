class RemoveStageNameFromDeployments < ActiveRecord::Migration[5.2]
  def change
    remove_column :deployments, :stage_name, :string
  end
end
