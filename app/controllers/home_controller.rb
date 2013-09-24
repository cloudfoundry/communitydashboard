class HomeController < ApplicationController
  respond_to :json

  def show
    respond_with PullRequest.all
  end
end
