class AddJiraLinkToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :jira_link, :string
  end
end
