require 'spec_helper'

describe PullRequest do
  describe '.from_github_response' do
    it 'does things' do
      #response = double(:something,
      #                  id: 0, number: 12, state: 'open', title:'title', body: 'body',
      #                  head: 'head', created_at: '2013-08-20 18:10:35 UTC', updated_at: '2013-08-31 12:55:43 UTC',
      #                  closed_at: nil, merged_at: nil
      #)
      WebMock.allow_net_connect!

      client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'], auto_paginate: true)
      pr = client.pull("cloudfoundry/dea_ng", "51")

      PullRequest.from_github_response(pr, 'org', 'repo')
    end
  end

  describe '.check_for_changes' do
    let(:pr_old) { PullRequest.new }
    let(:pr_new) { PullRequest.new }

    it 'returns an empty hash if both requests have the same significant fields' do
      pr_old.state = 'open'
      pr_new.state = 'open'

      expect(PullRequest.check_for_changes(pr_old, pr_new)).to eq({})
    end

    it 'returns the changes if the requests differ in their significant fields' do
      pr_old.state = 'open'
      pr_new.state = 'closed'

      pr_old.comments = 10
      pr_new.comments = 14

      expect(PullRequest.check_for_changes(pr_old, pr_new)).to eq({
        state: { 'open' => 'closed' },
        comments: { 10 => 14 },
      })
    end
  end
end
