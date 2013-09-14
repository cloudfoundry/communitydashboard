class PullsController < ApplicationController
  def index
    @pulls = []

    #
    client = Octokit::Client.new(access_token: 'REMOVED', auto_paginate: true)
    user = client.user
    user.login

    issues = client.org_issues('cloudfoudry', filter: "all")
    issues.select { |issue| issue.pull_request.rels[:html] }
  end
end
