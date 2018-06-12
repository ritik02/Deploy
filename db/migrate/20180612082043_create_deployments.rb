class CreateDeployments < ActiveRecord::Migration[5.2]
  def change
    create_table :deployments do |t|
    	t.integer :user_id
    	t.integer :project_id
    	t.string :commit_id
    	t.integer :reviewer_id
    	t.string :stage_name
    	t.string :job_name
    	t.text :checklist
    	t.string :status
      t.timestamps
    end
  end
end
