require 'spec_helper'

describe 'Pulls list' do
  it 'displays the list' do
    visit pulls_path

    stub_github_repo_list

    expect(page).to have_content('Pullrequests for cloudfoundry')
    expect(page).to have_css('table tr.pull')
  end
end
