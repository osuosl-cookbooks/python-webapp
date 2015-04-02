#
# Cookbook Name:: osl_application_python_test
# Recipe:: default
#
# Copyright 2015, OSU Open Source Lab
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

path = '/opt/whats_fresh/'

hash = {
  'path' => path,
  'engine' => 'django.db.backends.sqlite3',
  'dbname' => "#{path}/yourdatabasename.db",
}


python_webapp 'whats_fresh' do
  create_user true
  owner 'whats_fresh'
  group 'whats_fresh'

  repository 'https://github.com/osuosl/python-test-apps.git'

  config_template 'config.yml.erb'
  config_destination "#{path}/config.yml"
  config_vars hash
  django_migrate true
  django_collectstatic true
  interpreter 'python2.7'
  revision 'cookbook_test'
end

python_webapp 'working_waterfronts' do
  path '/opt/working_h2ofronts'
  virtualenv_path '/opt/venv_h2o'
  repository 'https://github.com/osuosl/python-test-apps.git'
  revision 'django'
  requirements_file nil
end
