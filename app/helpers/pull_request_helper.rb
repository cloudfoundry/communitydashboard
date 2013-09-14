module PullRequestHelper

  def self.fetch(org, token)
    client = Octokit::Client.new(access_token: token, auto_paginate: true)

    issues = client.org_issues(org, filter: 'all')

    pr_urls = issues.map { |i| i.pull_request.rels[:html].try(:href) }

    pr_urls.map do |u|
      pr_data = parse_uri(u)

      pr = client.pull_request("#{pr_data[:org]}/#{pr_data[:repo]}", pr_data[:id])

      {title: pr.title}
    end
  end

  private

  def self.parse_uri(uri)
    parts = URI(uri).path.split('/')

    {org: parts[1], repo: parts[2], id: parts[4].to_i}
  end

end
