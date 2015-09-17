require 'chefspec'
require 'spec_helper'

describe 'python-webapp-test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out Tutorial A and Tutorial B' do
    expect(chef_run).to sync_git('/opt/tutorial_a').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      revision: 'cookbook_test')
    expect(chef_run).to sync_git('/opt/tutorial_b').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      revision: 'django')
  end

  it 'creates user and group for Tutorial A' do
    expect(chef_run).to create_group('tutorial_a')
    expect(chef_run).to create_user('tutorial_a')
  end

  it 'creates directory for Tutorial A and Tutorial B' do
    expect(chef_run).to create_directory('/opt/tutorial_a').with(
      owner: 'tutorial_a', group: 'tutorial_a')
    expect(chef_run).to create_directory('/opt/tutorial_b').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Tutorial A and Tutorial B' do
    expect(chef_run).to create_python_virtualenv('/opt/tutorial_a/venv').with(
      owner: 'tutorial_a', group: 'tutorial_a', interpreter: 'python2.7')
    expect(chef_run).to create_python_virtualenv('/opt/venv_h2o').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates configuration files for Tutorial A and Tutorial B' do
    expect(chef_run).to create_template('config.yml.erb').with(
      owner: 'tutorial_a', group: 'tutorial_a')
    expect(chef_run).to create_template('settings.py.erb').with(
      owner: 'chef', group: 'chef')

    # TODO: we should render the passed-in settings
    expect(chef_run).to render_file('/opt/tutorial_a/config/config.yml')
    expect(chef_run).to render_file(
      '/opt/tutorial_b/settings.py')
  end

  it 'creates config directory for Tutorial A' do
    expect(chef_run).to create_directory('/opt/tutorial_a/config').with(
      owner: 'tutorial_a', group: 'tutorial_a', recursive: true)
  end

  it 'installs Tutorial A with setup.py' do
    expect(chef_run)
      .to run_bash('Install python dependencies tutorial_a').with(
        code: %r{/opt/tutorial_a/venv/bin/python setup.py install},
        cwd: '/opt/tutorial_a/source',
        user: 'tutorial_a')
  end

  it 'runs django migrations' do
    expect(chef_run).to run_bash('run migrations tutorial_a').with(
      code: %r{/opt/tutorial_a/venv/bin/python manage.py migrate --noinput},
      cwd: '/opt/tutorial_a/source',
      user: 'tutorial_a')
  end

  # rubocop:disable Metrics/LineLength
  it 'runs django collectstatic' do
    expect(chef_run).to run_bash('collect static resources tutorial_a').with(
      code: %r{/opt/tutorial_a/venv/bin/python manage.py collectstatic --noinput},
      cwd: '/opt/tutorial_a/source',
      user: 'tutorial_a')
  end
  # rubocop:enable Metrics/LineLength

  it 'installs and sets up gunicorn for Tutorial A' do
    expect(chef_run)
      .to create_gunicorn_config('/opt/tutorial_a/gunicorn_config.py').with(
        listen: '0.0.0.0:8888')
  end

  it 'installs and sets up supervisor for Tutorial A' do
    expect(chef_run)
      .to enable_supervisor_service('tutorial_a').with(
        command: '/opt/tutorial_a/venv/bin/gunicorn' \
          ' wsgi:app' \
          ' -c /opt/tutorial_a/gunicorn_config.py',
        autorestart: true,
        directory: '/opt/tutorial_a/source')
    expect(chef_run).to restart_supervisor_service('tutorial_a')
  end

  it 'installs gunicorn to Tutorial A virtualenv' do
    expect(chef_run)
      .to install_python_pip('gunicorn').with(
        virtualenv: '/opt/tutorial_a/venv')
  end

  it 'runs pip upgrade' do
    expect(chef_run)
      .to install_python_pip('setuptools').with(
        options: '--upgrade')
  end

  it 'includes supervisor recipe for Tutorial A' do
    expect(chef_run)
      .to include_recipe('supervisor')
  end
end

describe 'python-webapp-test::tutorial_c' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out Tutorial C' do
    expect(chef_run).to sync_git('/opt/tutorial_c').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      revision: 'cookbook_test')
  end

  it 'creates directory for Tutorial C' do
    expect(chef_run).to create_directory('/opt/tutorial_c').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Tutorial C' do
    expect(chef_run).to create_python_virtualenv('/opt/tutorial_c/venv').with(
      owner: 'chef', group: 'chef')
  end

  it 'installs special_requirements' do
    expect(chef_run)
      .to install_python_pip('/opt/tutorial_c/source/' \
        'special_requirements.txt').with(
          options: '-r')
  end

  it 'does not install supervisor recipe for Tutorial C' do
    expect(chef_run).not_to include_recipe('supervisor')
  end
end

describe 'python-webapp-test::tutorial_d' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'installs and sets up supervisor for Tutorial D' do
    expect(chef_run)
      .to enable_supervisor_service('tutorial_d').with(
        command: '/opt/tutorial_d/venv/bin/gunicorn' \
          ' tutorial_d.wsgi:application' \
          ' -c /opt/tutorial_d/gunicorn_config.py',
        autorestart: true,
        directory: '/opt/tutorial_d/source')
  end
end
