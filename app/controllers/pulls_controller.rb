class PullsController < ApplicationController

  def index
    @pull_requests = PullRequest.all
  end
end
