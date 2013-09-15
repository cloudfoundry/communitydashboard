module PullRequestHelper

  def self.fetch(org, token)
    client = Octokit::Client.new(access_token: token, auto_paginate: true)

    issues = client.org_issues(org, filter: 'all')


    prs = issues.select { |issue| issue.pull_request.rels[:html] }
    pr_urls = prs.map { |i| i.pull_request.rels[:html].try(:href) }

    r = {}

    pr_urls.each do |u|
      pr_data = parse_uri(u)

      r[u] = {
          'org' => pr_data[:org],
          'repo' => pr_data[:repo],
          'id' => pr_data[:id]
      }
    end
    r
  end

  private

  def self.parse_uri(uri)
    parts = URI(uri).path.split('/')

    {org: parts[1], repo: parts[2], id: parts[4].to_i}
  end

end
