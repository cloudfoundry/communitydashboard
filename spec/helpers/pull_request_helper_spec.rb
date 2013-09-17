require 'spec_helper'

describe PullRequestHelper do
  let(:client) { double('client') }

  describe '.fetch' do
    let(:issue) { double('issue') }

    it 'returns all the pull_requests for the organization' do
      Octokit::Client.should_receive(:new).with(access_token: 'token1', auto_paginate: true).and_return(client)

      client.should_receive(:org_issues).with('org1', filter: 'all').and_return([issue])

      relation = double('relation', href: 'https://github.com/org1/repo1/pull/1')
      issue.stub_chain(:pull_request, :rels).and_return(html: relation)

      expect(PullRequestHelper.fetch('token1', 'org1')).to eq(
        {
          'https://github.com/org1/repo1/pull/1' => {
            org: 'org1',
            repo: 'repo1',
            id: 1
          }
        })
    end
  end

  describe '.pull_request_data' do
    let(:params) { {org: 'org1', repo: 'repo1', id: 1} }
    let(:response) { double('pull_request', title: 'some title') }

    it 'returns details for a given pull request' do
      Octokit::Client.should_receive(:new).with(access_token: 'token1', auto_paginate: true).and_return(client)

      client.should_receive(:pull).with('org1/repo1', '1').and_return(response)

      expect(PullRequestHelper.pull_request_data('token1', params)).to eq({title:'some title'}.to_json)
    end
  end
end
