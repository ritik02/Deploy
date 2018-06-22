class AddJiraTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :jira_token, :string
  end
end
