require 'git'

actions :install
default_action :install

attribute :path, 'kind_of' => String, :default => '/opt/app/'
attribute :owner, 'kind_of' => String, :default => 'chef'
attribute :group, 'kind_of' => String, :default => 'chef'

attribute :git_repo, 'kind_of' => String
attribute :git_branch, 'kind_of' => String, :default => 'master'

attribute :config_template, 'kind_of' => String,
                            :default => 'settings.py.erb'
attribute :config_destination, 'kind_of' => String,
                               :default => 'settings.py'
attribute :config_vars, 'kind_of' => Hash
