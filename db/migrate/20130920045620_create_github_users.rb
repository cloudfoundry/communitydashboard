class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.integer :pull_request_id
      t.string :login, null: false
      t.integer :github_user_id, null: false
      t.string :gravatar_id

      t.timestamps
    end
  end
end
