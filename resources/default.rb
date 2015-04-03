#
# Cookbook Name:: python-webapp
# Resource:: default
#
# Copyright 2015, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default_action :install

# Creates the user if they do not already exist
attribute :create_user, 'kind_of' => [TrueClass, FalseClass], :default => false

# Create the owner, path, or group if they do not exist
# If path is nil it will default to '/opt/<name_attribute>'
attribute :path, 'kind_of' => [String, NilClass], :default => nil
attribute :owner, 'kind_of' => String, :default => 'chef'
attribute :group, 'kind_of' => String, :default => 'chef'

# The information necessary to check out the code
attribute :repository, 'kind_of' => String
attribute :revision, 'kind_of' => String, :default => 'master'

# Location of the virtualenv
attribute :virtualenv_path, 'kind_of' => [String, NilClass], :default => nil

# Specify the config file template, destination on the node, and variables
# If :config_template is nil, do nothing
attribute :config_template, 'kind_of' => [String, NilClass],
                            :default => 'settings.py.erb'
# The destination is an absolute path, or nil
attribute :config_destination, 'kind_of' => [String, NilClass], :default => nil
attribute :config_vars, 'kind_of' => Hash

# If this is set, install that requirements file. If it is not, install a
# setup.py. If the setup.py does not exist, fail.
attribute :requirements_file, 'kind_of' => [String, NilClass], :default => nil

# These attributes will only work for Django apps
attribute :django_migrate, 'kind_of' => [TrueClass, FalseClass],
                           :default => false

attribute :django_collectstatic, 'kind_of' => [TrueClass, FalseClass],
                                 :default => false

attribute :interpreter, 'kind_of' => String, :default => 'python'
