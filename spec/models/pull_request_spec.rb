require 'spec_helper'

describe PullRequest do
  let(:organization) { 'ballin_org' }
  let(:repository) { 'ballin_repository' }
  let(:number) { 1337 }
  let(:github_user) do
    gu = GithubUser.new
    gu.gravatar_id = 'fravatar_id'
    gu.login       = 'githubuser_login'
    gu
  end

  describe '.from_github_response' do
    let(:response) {
      double( :something,
              id: 0, number: 12, state: 'open', title:'title', body: 'body',
              head: double(:head, sha: 'head'), created_at: '2013-08-20 18:10:35 UTC', updated_at: '2013-08-31 12:55:43 UTC',
              closed_at: nil, merged_at: nil, merge_commit_sha: "FSDRE", merged: false, mergeable: nil, mergeable_state: 'yes',
              comments: 42, review_comments: 43, commits: 44, additions: 45, deletions: 46, changed_files: 47,
              user: double(:user, login: 'abc', id: 123, gravatar_id: 'sdg')
      )
    }

    context 'when the PR has not yet been stored in the database' do
      it 'creates a new Database entry' do
        expect{ PullRequest.from_github_response(response, 'org', 'repo') }.
            to change{ PullRequest.count }.from(0).to(1)
      end

      it 'marks the returned PR as changed' do
        expect(PullRequest.from_github_response(response, 'org', 'repo').has_changed).to be_true
      end

      it 'sets the update_available flag' do
        expect( PullRequest.from_github_response(response, 'org', 'repo').update_available ).to be_true
      end
    end

    context 'when the PR is already stored in the database' do
      before do
        PullRequest.from_github_response(response, 'org', 'repo')
      end

      context 'and there are no changes' do
        let(:response2) {
          double( :something,
                  id: 0, number: 12, state: 'open', title:'title', body: 'body',
                  head: double(:head, sha: 'head'), created_at: '2013-08-20 18:10:35 UTC', updated_at: '2013-08-31 12:55:43 UTC',
                  closed_at: nil, merged_at: nil, merge_commit_sha: "FSDRE", merged: false, mergeable: nil, mergeable_state: 'yes',
                  comments: 42, review_comments: 43, commits: 44, additions: 45, deletions: 46, changed_files: 47,
                  user: double(:user, login: 'abc', id: 123, gravatar_id: 'sdg')
          )
        }

        it 'does not create a new Database entry' do
          expect{ PullRequest.from_github_response(response2, 'org', 'repo') }.
              to_not change{ PullRequest.count }
        end

        it 'marks the returned PR as not changed' do
          expect(PullRequest.from_github_response(response2, 'org', 'repo').has_changed).to be_false
        end

        it 'does not return any changes' do
          expect(PullRequest.from_github_response(response2, 'org', 'repo').get_changes).to be_empty
        end
      end

      context 'and there are changes' do
        let(:response2) {
          double( :something,
                  id: 0, number: 12, state: 'open', title:'title', body: 'body',
                  head: double(:head, sha: 'head'), created_at: '2013-08-20 18:10:35 UTC', updated_at: '2013-08-31 12:55:43 UTC',
                  closed_at: nil, merged_at: nil, merge_commit_sha: "FSDRE", merged: false, mergeable: nil, mergeable_state: 'yes',
                  comments: 45, review_comments: 47, commits: 44, additions: 50, deletions: 60, changed_files: 55,
                  user: double(:user, login: 'abc', id: 123, gravatar_id: 'sdg')
          )
        }

        it 'does not create a new Database entry' do
          expect{ PullRequest.from_github_response(response2, 'org', 'repo') }.
              to_not change{ PullRequest.count }
        end

        it 'marks the returned PR as changed' do
          expect(PullRequest.from_github_response(response2, 'org', 'repo').has_changed).to be_true
        end

        it 'returns the changed fields' do
          expect(PullRequest.from_github_response(response2, 'org', 'repo').get_changes).to_not be_empty
        end

        it 'alters the update_available flag' do
          old = PullRequest.first
          old.update_attribute('update_available', false)

          expect{ PullRequest.from_github_response(response2, 'org', 'repo') }.
              to change{PullRequest.first.update_available}.from(false).to(true)
        end
      end
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
        state: ['open', 'closed'],
        comments: [10, 14],
      })
    end
  end

  subject do
    pr              = PullRequest.new
    pr.organization = organization
    pr.repository   = repository
    pr.number       = number
    pr.github_user  = github_user
    pr
  end

  its(:url)              { should eq "https://github.com/ballin_org/ballin_repository/pull/1337" }
  its(:repository_title) { should eq "ballin_org/ballin_repository" }
  its(:repository_url)   { should eq "https://github.com/ballin_org/ballin_repository" }
  its(:gravatar_url)     { should eq "https://www.gravatar.com/avatar/fravatar_id?s=80" }
  its(:user_url)         { should eq "https://github.com/githubuser_login" }

end