action :install do
  # Update the code.
  git new_resource.path do
    action :sync
    repository new_resource.repository
    checkout_branch new_resource.revision
    destination new_resource.path
    user new_resource.owner
    group new_resource.group
  end

  # If a config file template has been specified, create it.
  template new_resource.config_template do
    only_if { !new_resource.config_template.nil }
    action :create
    source new_resource.config_template
    path new_resource.config_destination
    variables new_resource.config_vars
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
  end

  # Install the application requirements.
  # If a requirements file has been specified, use pip.
  # otherwise use the setup.py
  if new_resource.requirements_file
    execute 'pip install' do
      action :run
      cwd new_resource.path
      command "pip install -r #{new_resource.requirements_file}"
    end
  else
    execute 'python setup.py install' do
      action :run
      cwd new_resource.path
    end
  end
  new_resource.updated_by_last_action(true)
end
