class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :gitlab_token
      t.string :username ,:unique => true ,:null => false
      t.integer :gitlab_user_id ,:unique => true
      t.timestamps
    end
  end
end
