module PullRequestHelper

  def self.fetch(org, token)
    result = {}
    fetch_url_list(org, token).each do |url|
      pr_data = parse_uri(url)
      result[url] = {
          'org' => pr_data[:org],
          'repo' => pr_data[:repo],
          'id' => pr_data[:id]
      }
    end
    result
  end

  private

  def self.fetch_url_list(org, token)
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
