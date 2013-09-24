class PullRequest < ActiveRecord::Base
  has_one :github_user

  def set_changed=(value)
    @changed = value
  end

  def set_changes=(value)
    @changes = value
  end

  def has_changed
    @changed
  end

  def get_changes
    @changes
  end

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
    pr.head = response.head.sha
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
      pr.set_changes = check_for_changes(other, pr)
      unless pr.get_changes.empty?

        other.update_attributes!(PullRequest.extract_update_hash(pr.get_changes))

        pr.set_changed = true

        puts "updated '#{pr.title}'"
      end

      puts "nothing to do for '#{pr.title}'"
    else
      pr.save!

      GithubUser.create!(pull_request: pr, login: response.user.login, github_user_id: response.user.id, gravatar_id: response.user.gravatar_id)
      pr.set_changed = true

      puts "created '#{pr.title}'"
    end

    pr
  end

  def self.check_for_changes(old, new)
    changes = {}

    COMPARED_FIELDS.each do |field|
      unless old.public_send(field) == new.public_send(field)
        changes[field] = [old.public_send(field), new.public_send(field)]
      end
    end

    changes
  end

  def url
    "https://github.com/#{organization}/#{repository}/#{number}"
  end

  def repository_title
    "#{organization}/#{repository}"
  end

  def repository_url
    "https://github.com/#{organization}/#{repository}"
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{github_user.gravatar_id}?s=80"
  end

  def user_url
    "https://github.com/#{github_user.login}"
  end

  private

  def self.extract_update_hash(changes)
    result = {}
    changes.each do |key, value|
      result[key] = value[1]
    end
    result
  end
end
