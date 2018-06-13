
ActiveRecord::Schema.define(version: 2018_06_13_060605) do

  enable_extension "plpgsql"

  create_table "deployments", force: :cascade do |t|
    t.integer "user_id"
    t.string "commit_id"
    t.integer "reviewer_id"
    t.text "checklist"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "project_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "gitlab_token"
    t.string "username", null: false
    t.integer "gitlab_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
