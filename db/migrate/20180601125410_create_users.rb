class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :gitlab_token
      t.string :username ,:unique => true ,:null => false
      t.timestamps
    end
  end
end
