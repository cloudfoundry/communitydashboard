module PullRequestHelper
  extend ActionView::Helpers::TextHelper

  def self.fetch_pr_list(token, org)
    pull_requests = {}
    fetch_url_list(token, org).each do |url|
      pr_data = parse_uri(url)
      pull_requests[url] = {
          org: pr_data[:org],
          repo: pr_data[:repo],
          id: pr_data[:id]
      }
    end
    pull_requests
  end

  def self.create_or_update_pull_request(token, org, repo, pr_id)
    client = Octokit::Client.new(access_token: token, auto_paginate: true)
    pr = client.pull("#{org}/#{repo}", "#{pr_id}")

    PullRequest.from_github_response(pr, org, repo)
  end

  def self.fetch_pull_request_data(token, org, repo, pr_id)
    client = Octokit::Client.new(access_token: token, auto_paginate: true)
    pr = client.pull("#{org}/#{repo}", "#{pr_id}")

    response = { title: pr.title, body: truncate( pr.body, length: 105 )}
    response.to_json
  end

  private

  def self.fetch_url_list(token, org)
    client = Octokit::Client.new(access_token: token, auto_paginate: true)

    issues = client.org_issues(org, filter: 'all')
    prs = issues.select { |issue| issue.pull_request.rels[:html] }
    prs.map { |issue| issue.pull_request.rels[:html].try(:href) }
  end

  def self.parse_uri(uri)
    parts = URI(uri).path.split('/')

    {org: parts[1], repo: parts[2], id: parts[4].to_i}
  end
end
