class PullRequest < ActiveRecord::Base
  has_one :github_user

  attr_accessor :changes, :changed

  COMPARED_FIELDS = [
      :state,
      :gh_updated_at,
      :closed_at,
      :merged_at,
      :merged,
      :mergeable,
      :mergeable_state,
      :comments,
      :review_comments,
      :commits,
      :additions,
      :deletions,
      :changed_files,
  ]

  def self.from_github_response(response, organization, repository)
    pr = PullRequest.new

    pr.github_id = response.id
    pr.number = response.number
    pr.state = response.state
    pr.title = response.title
    pr.body = response.body
    pr.head = response.head
    pr.gh_created_at = response.created_at
    pr.gh_updated_at = response.updated_at
    pr.closed_at = response.closed_at
    pr.merged_at = response.merged_at
    pr.merge_commit_sha = response.merge_commit_sha
    pr.merged = response.merged
    pr.mergeable = response.mergeable
    pr.mergeable_state = response.mergeable_state
    pr.comments = response.comments
    pr.review_comments = response.review_comments
    pr.commits = response.commits
    pr.additions = response.additions
    pr.deletions = response.deletions
    pr.changed_files = response.changed_files
    pr.organization = organization
    pr.repository = repository

    other = PullRequest.find_by_github_id(pr.github_id)
    if other
      pr.changes = check_for_changes(other, pr)
      unless chagnges.empty?
        pr.save!
        pr.changed = true

        puts "updated #{pr.organization}/#{pr.repository}/#{pr.number} ot database"
      end

      puts "no changes for #{pr.organization}/#{pr.repository}/#{pr.number}"
    else
      pr = pr.save!
      pr.changed = true
      pr.user = GithubUser.create!(pull_request: pr, login: response.user.login, id: response.user.id, gravatar_id: response.user.gravatar_id)
      puts "created #{pr.organization}/#{pr.repository}/#{pr.number} ot database"
    end
  end

  def self.check_for_changes(old, new)
    changes = {}

    COMPARED_FIELDS.each do |field|
      unless old.public_send(field) == new.public_send(field)
        changes[field] = { old.public_send(field) => new.public_send(field) }
      end
    end

    changes
  end
end
