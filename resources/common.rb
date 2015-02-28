require 'git'

actions :install
default_action :install

# Create the owner, path, or group if they do not exist
attribute :path, 'kind_of' => String, :default => '/opt/app/'
attribute :owner, 'kind_of' => String, :default => 'chef'
attribute :group, 'kind_of' => String, :default => 'chef'

# The information necessary to check out the code
attribute :git_repo, 'kind_of' => String
attribute :git_branch, 'kind_of' => String, :default => 'master'

# Specify the config file template, destination on the node, and variables
attribute :config_template, 'kind_of' => String,
                            :default => 'settings.py.erb'
attribute :config_destination, 'kind_of' => String,
                               :default => 'settings.py'
attribute :config_vars, 'kind_of' => Hash
