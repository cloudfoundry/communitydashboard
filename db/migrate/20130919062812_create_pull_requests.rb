class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :github_id, null: false
      t.integer :number, null: false
      t.string :state, null: false
      t.string :title, null: false
      t.text   :body
      t.string :head, null: false
      t.datetime :gh_created_at
      t.datetime :gh_updated_at
      t.datetime :closed_at
      t.datetime :merged_at
      t.string :merge_commit_sha
      t.boolean :merged
      t.boolean :mergeable
      t.string :mergeable_state
      t.integer :comments
      t.integer :review_comments
      t.integer :commits
      t.integer :additions
      t.integer :deletions
      t.integer :changed_files
      t.string :organization
      t.string :repository

      t.timestamps
    end
  end
end
