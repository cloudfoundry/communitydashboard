class PullsController < ApplicationController
  respond_to :json

  def index
    @pulls = []

    #client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'], auto_paginate: true)
    #user = client.user
    #user.login

    #issues = client.org_issues('cloudfoudry', filter: "all")
    #issues.select { |issue| issue.pull_request.rels[:html] }

    respond_with PullRequestHelper.fetch('cloudfoundry', ENV['GITHUB_TOKEN'])
  end

  def show
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'], auto_paginate: true)
    pr = client.pull("#{params[:org]}/#{params[:repo]}", "#{params[:id]}")

    response = {title: pr.title}

    respond_with response.to_json
  end
end
