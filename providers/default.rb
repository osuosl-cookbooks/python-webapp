action :install do
  # Use the git recipe to install git
  run_context.include_recipe 'git'
  run_context.include_recipe 'python::pip'
  run_context.include_recipe 'python::virtualenv'

  if new_resource.create_user
    group new_resource.group do
      action :create
    end
    user new_resource.owner do
      action :create
      gid new_resource.group
    end
  end

  # If the new_resource.path is nil set the install path to
  # `/opt/name_attribute`
  path = new_resource.path || "/opt/#{ new_resource.name }"

  if new_resource.virtualenv_path.nil?
    virtualenv_path = "/opt/venv_#{ new_resource.name }"
  else
    virtualenv_path = new_resource.virtualenv_path
  end

  # If the config_destination is nil, as by default, default to
  # /opt/<path>/settings.py
  if new_resource.config_destination.nil?
    config_destination = "#{ path }/settings.py"
  else
    config_destination = new_resource.config_destination
  end

  directory path do
    action :create
    recursive true
    owner new_resource.owner
    group new_resource.group
  end

  # Create virtual environment
  python_virtualenv virtualenv_path do
    interpreter new_resource.interpreter
    owner new_resource.owner
    group new_resource.group
    action :create
  end

  # Update the code.
  git path do
    action :sync
    repository new_resource.repository
    checkout_branch new_resource.revision
    destination path
    user new_resource.owner
    group new_resource.group
  end

  # If a config file template has been specified, create it.
  template new_resource.config_template do
    only_if { !new_resource.config_template.nil? }
    action :create
    source new_resource.config_template
    path config_destination
    variables new_resource.config_vars
    owner new_resource.owner
    group new_resource.group
  end

  # Install the application requirements.
  # If a requirements file has been specified, use pip.
  # otherwise use the setup.py
  if new_resource.requirements_file.nil?
    bash "Install python dependencies" do
      user new_resource.owner
      cwd path
      code <<-EOH
        #{virtualenv_path}/bin/python setup.py install
      EOH
    end

  else
    python_pip "#{ path }/#{ new_resource.requirements_file }" do
      action :install
      options '-r'
      virtualenv virtualenv_path
    end
  end

  # Run django migrations if the django_migrate flag is set
  bash "run migrations #{new_resource.name}" do
    user new_resource.owner
    cwd path
    code <<-EOH
      #{virtualenv_path}/bin/python manage.py migrate --noinput
    EOH
    only_if { new_resource.django_migrate }
  end

  # Run the django collectstatic command if the django_collectstatic flag
  # is set
  bash "collect static resources #{new_resource.name}" do
    user new_resource.owner
    cwd path
    code <<-EOH
      #{virtualenv_path}/bin/python manage.py collectstatic --noinput
    EOH
    only_if { new_resource.django_collectstatic }
  end

  new_resource.updated_by_last_action(true)
end
