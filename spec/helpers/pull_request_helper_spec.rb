require 'spec_helper'

describe PullRequestHelper do

  describe '.fetch' do
    let(:client) { double('client') }

    let(:issue) { double('issue') }

    let(:pr_resource) { double('resource', title: 'title 1') }

    it 'returns all the pull_requests for the organization' do
      Octokit::Client.should_receive(:new).with(access_token: 'token1', auto_paginate: true).and_return(client)

      client.should_receive(:org_issues).with('org1', filter: 'all').and_return([issue])

      relation = double('relation', href: 'https://github.com/org1/repo1/pull/1')

      issue.stub_chain(:pull_request, :rels).and_return(html: relation)

      client.should_receive(:pull_request).with('org1/repo1', 1).and_return(pr_resource)

      expect(PullRequestHelper.fetch('org1', 'token1')).to eq [{title: 'title 1'}]
    end
  end

end
