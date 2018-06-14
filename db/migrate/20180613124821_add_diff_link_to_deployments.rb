class AddDiffLinkToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :diff_link, :string
  end
end
