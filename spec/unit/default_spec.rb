require 'chefspec'
require 'spec_helper'

describe 'python-webapp-test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out Tutorial A and Tutorial B' do
    expect(chef_run).to sync_git('/opt/tutorial-a').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      checkout_branch: 'cookbook_test')
    expect(chef_run).to sync_git('/app/tutorial-b').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      checkout_branch: 'django')
  end

  it 'creates user and group for Tutorial A' do
    expect(chef_run).to create_group('tutorial-a')
    expect(chef_run).to create_user('tutorial-a')
  end

  it 'creates directory for Tutorial A and Tutorial B' do
    expect(chef_run).to create_directory('/opt/tutorial-a').with(
      owner: 'tutorial-a', group: 'tutorial-a')
    expect(chef_run).to create_directory('/app/tutorial-b').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Tutorial A and Tutorial B' do
    expect(chef_run).to create_python_virtualenv('/opt/venv_tutorial-a').with(
      owner: 'tutorial-a', group: 'tutorial-a', interpreter: 'python2.7')
    expect(chef_run).to create_python_virtualenv('/opt/venv_h2o').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates configuration files for Tutorial A and Tutorial B' do
    expect(chef_run).to create_template('config.yml.erb').with(
      owner: 'tutorial-a', group: 'tutorial-a')
    expect(chef_run).to create_template('settings.py.erb').with(
      owner: 'chef', group: 'chef')

    # TODO: we should render the passed-in settings
    expect(chef_run).to render_file('/opt/tutorial-a/config.yml')
    expect(chef_run).to render_file(
      '/app/tutorial-b/settings.py')
  end

  # rubocop:disable Metrics/LineLength
  it 'installs Tutorial A with setup.py' do
    expect(chef_run)
      .to run_bash('Install python dependencies tutorial-a').with(
        code: %r{/opt/venv_tutorial-a/bin/python setup.py install},
        cwd: '/opt/tutorial-a',
        user: 'tutorial-a')
  end

  it 'runs django migrations' do
    expect(chef_run).to run_bash('run migrations tutorial-a').with(
      code: %r{/opt/venv_tutorial-a/bin/python manage.py migrate --noinput},
      cwd: '/opt/tutorial-a',
      user: 'tutorial-a')
  end

  # rubocop:disable Metrics/LineLength
  it 'runs django collectstatic' do
    expect(chef_run).to run_bash('collect static resources tutorial-a').with(
      code: %r{/opt/venv_tutorial-a/bin/python manage.py collectstatic --noinput},
      cwd: '/opt/tutorial-a',
      user: 'tutorial-a')
  end
  # rubocop:enable Metrics/LineLength

  it 'installs and sets up gunicorn for Whats Fresh' do
    expect(chef_run)
      .to create_gunicorn_config('/opt/whats_fresh/gunicorn_config.py').with(
        listen: '0.0.0.0:8888')
  end

  it 'installs and sets up supervisor for Whats Fresh' do
    expect(chef_run)
      .to enable_supervisor_service('whats_fresh').with(
        command: '/opt/venv_whats_fresh/bin/gunicorn' \
          ' whats_fresh.wsgi:application' \
          ' -c /opt/whats_fresh/gunicorn_config.py',
        autorestart: true,
        directory: '/opt/whats_fresh')
  end
end

describe 'python-webapp-test::pgd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out PGD' do
    expect(chef_run).to sync_git('/opt/pgd').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      checkout_branch: 'cookbook_test')
  end

  it 'creates directory for PGD' do
    expect(chef_run).to create_directory('/opt/pgd').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for PGD' do
    expect(chef_run).to create_python_virtualenv('/opt/venv_pgd').with(
      owner: 'chef', group: 'chef')
  end

  it 'installs special_requirements' do
    expect(chef_run).to install_python_pip('/opt/pgd/special_requirements.txt')
      .with(options: '-r')
  end
end
