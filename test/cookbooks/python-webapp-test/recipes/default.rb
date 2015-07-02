#
# Cookbook Name:: osl_application_python_test
# Recipe:: default
#
# Copyright 2015, Oregon State University
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

group 'chef' do
  action :create
end

user 'chef' do
  action :create
  gid 'chef'
end

path = '/opt/tutorial_a'

hash = {
  'path' => path,
  'engine' => 'django.db.backends.sqlite3',
  'dbname' => "#{path}/yourdatabasename.db"
}

python_webapp 'tutorial_a' do
  create_user true
  owner 'tutorial_a'
  group 'tutorial_a'

  repository 'https://github.com/osuosl/python-test-apps.git'

  config_template 'config.yml.erb'
  config_destination "#{path}/config/config.yml"
  config_vars hash
  django_migrate true
  django_collectstatic true
  interpreter 'python2.7'
  revision 'cookbook_test'

  gunicorn_port 8888
end

python_webapp 'tutorial_b' do
  path '/opt/tutorial_b'
  virtualenv_path '/opt/venv_h2o'
  repository 'https://github.com/osuosl/python-test-apps.git'
  revision 'django'
  requirements_file nil
end
