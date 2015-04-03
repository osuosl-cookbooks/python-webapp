require 'chefspec'
require 'spec_helper'

describe 'python-webapp-test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out Whats Fresh and Working Waterfronts' do
    expect(chef_run).to sync_git('/opt/whats_fresh').with(
      repository: 'https://github.com/osuosl/python-test-apps.git')
    expect(chef_run).to sync_git('/opt/working_h2ofronts').with(
      repository: 'https://github.com/osuosl/python-test-apps.git')
  end

  it 'creates user and group for Whats Fresh' do
    expect(chef_run).to create_group('whats_fresh')
    expect(chef_run).to create_user('whats_fresh')
  end

  it 'creates directory for Whats Fresh and Working Waterfronts' do
    expect(chef_run).to create_directory('/opt/whats_fresh').with(
      owner: 'whats_fresh', group: 'whats_fresh')
    expect(chef_run).to create_directory('/opt/working_h2ofronts').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Whats Fresh and Working Waterfronts' do
    expect(chef_run).to create_python_virtualenv('/opt/venv_whats_fresh').with(
      owner: 'whats_fresh', group: 'whats_fresh', interpreter: 'python2.7')
    expect(chef_run).to create_python_virtualenv('/opt/venv_h2o').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates configuration files for Whats Fresh and Working Waterfronts' do
    expect(chef_run).to create_template('config.yml.erb').with(
      owner: 'whats_fresh', group: 'whats_fresh')
    expect(chef_run).to create_template('settings.py.erb').with(
      owner: 'chef', group: 'chef')

    # TODO: we should render the passed-in settings
    expect(chef_run).to render_file('/opt/whats_fresh/config.yml')
    expect(chef_run).to render_file(
      '/opt/working_h2ofronts/settings.py')
  end
end

describe 'python-webapp-test::pgd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out PGD' do
    expect(chef_run).to sync_git('/opt/pgd').with(
      repository: 'https://github.com/osuosl/python-test-apps.git')
  end

  it 'creates directory for PGD' do
    expect(chef_run).to create_directory('/opt/pgd').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Whats Fresh and Working Waterfronts' do
    expect(chef_run).to create_python_virtualenv('/opt/venv_pgd').with(
      owner: 'chef', group: 'chef')
  end

  it 'installs special_requirements' do
    expect(chef_run).to install_python_pip('/opt/pgd/special_requirements.txt')
      .with(options: '-r')
  end
end
