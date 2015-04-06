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
      checkout_branch: 'cookbook_test')
    expect(chef_run).to sync_git('/opt/tutorial_b').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      checkout_branch: 'django')
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
    expect(chef_run).to create_python_virtualenv('/opt/venv_tutorial_a').with(
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
    expect(chef_run).to render_file('/opt/tutorial_a/config.yml')
    expect(chef_run).to render_file(
      '/opt/tutorial_b/settings.py')
  end

<<<<<<< HEAD
  it 'installs Tutorial A with setup.py' do
||||||| merged common ancestors
  # rubocop:disable Metrics/LineLength
  it 'installs Whats Fresh with setup.py' do
=======
  it 'installs Whats Fresh with setup.py' do
>>>>>>> 9422751459aa5b832160096e9e707a0141e49162
    expect(chef_run)
      .to run_bash('Install python dependencies tutorial_a').with(
        code: %r{/opt/venv_tutorial_a/bin/python setup.py install},
        cwd: '/opt/tutorial_a',
        user: 'tutorial_a')
  end

  it 'runs django migrations' do
    expect(chef_run).to run_bash('run migrations tutorial_a').with(
      code: %r{/opt/venv_tutorial_a/bin/python manage.py migrate --noinput},
      cwd: '/opt/tutorial_a',
      user: 'tutorial_a')
  end

  # rubocop:disable Metrics/LineLength
  it 'runs django collectstatic' do
    expect(chef_run).to run_bash('collect static resources tutorial_a').with(
      code: %r{/opt/venv_tutorial_a/bin/python manage.py collectstatic --noinput},
      cwd: '/opt/tutorial_a',
      user: 'tutorial_a')
  end
  # rubocop:enable Metrics/LineLength
<<<<<<< HEAD

  it 'installs and sets up gunicorn for Tutorial A' do
    expect(chef_run)
      .to create_gunicorn_config('/opt/tutorial_a/gunicorn_config.py').with(
        listen: '0.0.0.0:8888')
  end

  it 'installs and sets up supervisor for Tutorial A' do
    expect(chef_run)
      .to enable_supervisor_service('tutorial_a').with(
        command: '/opt/venv_tutorial_a/bin/gunicorn' \
          ' tutorial_a.wsgi:application' \
          ' -c /opt/tutorial_a/gunicorn_config.py',
        autorestart: true,
        directory: '/opt/tutorial_a')
  end

  it 'installs gunicorn to Tutorial A virtualenv' do
    expect(chef_run)
      .to install_python_pip('gunicorn').with(
        virtualenv: '/opt/venv_tutorial_a')
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
||||||| merged common ancestors
=======

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

  it 'installs gunicorn to Whats Fresh virtualenv' do
    expect(chef_run)
      .to install_python_pip('gunicorn').with(
        virtualenv: '/opt/venv_whats_fresh')
  end

  it 'runs pip upgrade in bash' do
    expect(chef_run)
      .to run_bash('manually upgrade setuptools').with(
        code: /pip install --upgrade setuptools/)
  end

  it 'includes supervisor recipe for Whats Fresh' do
    expect(chef_run)
      .to include_recipe('supervisor')
  end
>>>>>>> 9422751459aa5b832160096e9e707a0141e49162
end

describe 'python-webapp-test::tutorial_c' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: ['python_webapp']).converge(described_recipe)
  end

  it 'checks out Tutorial C' do
    expect(chef_run).to sync_git('/opt/tutorial_c').with(
      repository: 'https://github.com/osuosl/python-test-apps.git',
      checkout_branch: 'cookbook_test')
  end

  it 'creates directory for Tutorial C' do
    expect(chef_run).to create_directory('/opt/tutorial_c').with(
      owner: 'chef', group: 'chef')
  end

  it 'creates virtualenvs for Tutorial C' do
    expect(chef_run).to create_python_virtualenv('/opt/venv_tutorial_c').with(
      owner: 'chef', group: 'chef')
  end

  it 'installs special_requirements' do
    expect(chef_run)
      .to install_python_pip('/opt/tutorial_c/special_requirements.txt').with(
        options: '-r')
  end

  it 'does not install supervisor recipe for Tutorial C' do
    expect(chef_run).not_to include_recipe('supervisor')
  end

  it 'does not install supervisor recipe for PGD' do
    expect(chef_run).not_to include_recipe('supervisor')
  end
end
