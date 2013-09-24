class AddUpdatesAvailableToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :update_available, :boolean
  end
end
