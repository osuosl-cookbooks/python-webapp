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
    expect(chef_run).to sync_git('/opt/tutorial-b').with(
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
    expect(chef_run).to create_directory('/opt/tutorial-b').with(
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
      '/opt/tutorial-b/settings.py')
  end

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

  it 'installs and sets up gunicorn for Tutorial A' do
    expect(chef_run)
      .to create_gunicorn_config('/opt/tutorial-a/gunicorn_config.py').with(
        listen: '0.0.0.0:8888')
  end

  it 'installs and sets up supervisor for Tutorial A' do
    expect(chef_run)
      .to enable_supervisor_service('tutorial-a').with(
        command: '/opt/venv_tutorial-a/bin/gunicorn' \
          ' tutorial-a.wsgi:application' \
          ' -c /opt/tutorial-a/gunicorn_config.py',
        autorestart: true,
        directory: '/opt/tutorial-a')
  end

  it 'installs gunicorn to Tutorial A virtualenv' do
    expect(chef_run)
      .to install_python_pip('gunicorn').with(
        virtualenv: '/opt/venv_tutorial-a')
  end

  it 'runs pip upgrade in bash' do
    expect(chef_run)
      .to run_bash('manually upgrade setuptools').with(
        code: /pip install --upgrade setuptools/)
  end

  it 'includes supervisor recipe for Tutorial A' do
    expect(chef_run)
      .to include_recipe('supervisor')
  end
end

describe 'python-webapp-test::tutorial-c' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out Tutorial C' do
    expect(chef_run).to sync_git('/opt/tutorial-c').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      checkout_branch: 'cookbook_test')
  end

  it 'creates directory for Tutorial C' do
    expect(chef_run).to create_directory('/opt/tutorial-c').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Tutorial C' do
    expect(chef_run).to create_python_virtualenv('/opt/venv_tutorial-c').with(
      owner: 'chef', group: 'chef')
  end

  it 'installs special_requirements' do
    expect(chef_run)
      .to install_python_pip('/opt/tutorial-c/special_requirements.txt').with(
        options: '-r')
  end

  it 'does not install supervisor recipe for Tutorial C' do
    expect(chef_run).not_to include_recipe('supervisor')
  end
end
