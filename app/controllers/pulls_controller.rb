class PullsController < ApplicationController
  #respond_to :json

  def index
    #respond_with PullRequestHelper.fetch(ENV['GITHUB_TOKEN'], 'cloudfoundry')
    #respond_with PullRequest.all
    @pull_requests = PullRequest.all
  end

  def show
    #respond_with PullRequestHelper.pull_request_data(ENV['GITHUB_TOKEN'], params )
  end
end
