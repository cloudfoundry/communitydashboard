class PullRequestFetcher
  extend ActionView::Helpers::TextHelper

  @queue = :medium

  def self.perform
    puts "#{Time.now} - Performing pull request data update"

    pr_list = PullRequestHelper.fetch_pr_list(ENV['GITHUB_TOKEN'], 'cloudfoundry')

    pr_list.each do |url, data|
      PullRequestHelper.create_or_update_pull_request(ENV['GITHUB_TOKEN'], data[:org], data[:repo], data[:id])
    end
  end
end
