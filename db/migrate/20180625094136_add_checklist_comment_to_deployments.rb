class AddChecklistCommentToDeployments < ActiveRecord::Migration[5.2]
  def change
    add_column :deployments, :checklist_comment, :string
  end
end
