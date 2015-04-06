#
# Cookbook Name:: python-webapp-test
# Recipe:: tutorial-c
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

include_recipe 'yum-ius'
include_recipe 'yum-epel'

%w(gcc python27 python27-devel python27-pip).each do |pkg|
  package pkg
end

group 'chef' do
  action :create
end

user 'chef' do
  action :create
  gid 'chef'
end

python_webapp 'tutorial-c' do
  path nil
  requirements_file 'special_requirements.txt'

  django_migrate false
  django_collectstatic false

  repository 'https://github.com/osuosl/python-test-apps.git'

  config_template nil
  revision 'cookbook_test' # TODO: set this to nil
end
