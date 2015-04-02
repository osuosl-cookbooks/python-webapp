require 'chefspec'
require 'spec_helper'

describe 'python-webapp-test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
        step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'includes git recipe' do
    expect(chef_run).to include_recipe('git')
  end

  it 'checks out Whats Fresh' do
    expect(chef_run).to sync_git('/opt/whats_fresh').with(
      repository: 'https://github.com/osuosl/python-test-apps.git')
  end

  it 'checks out Working Waterfronts' do
    expect(chef_run).to sync_git('/opt/working_h2ofronts').with(
      repository: 'https://github.com/osuosl/python-test-apps.git')
  end
end
