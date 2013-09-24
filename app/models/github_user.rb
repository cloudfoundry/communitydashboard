class GithubUser < ActiveRecord::Base
  belongs_to :pull_request
end
