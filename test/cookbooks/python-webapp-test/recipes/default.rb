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

group 'chef' do
  action :create
end

user 'chef' do
  action :create
  gid 'chef'
end

python_webapp_common 'whats_fresh' do
  create_user true
  owner 'whats_fresh'
  group 'whats_fresh'

  repository 'https://github.com/osu-cass/whats-fresh-api.git'

  config_template 'config.yml.erb'
  config_destination '/opt/whats_fresh/whats_fresh/config.yml'
  config_vars(
    host: 'db.example.com',
    port: '5432',
    username: 'user',
    password: 'pass',
    db_name: 'database',
    secret_key: 'abcd'
  )
end

python_webapp_common 'working_waterfronts' do
  path '/opt/working_h2ofronts'
  virtualenv_path '/opt/venv_h2o'
  repository 'https://github.com/osu-cass/working-waterfronts-api.git'
  revision 'eb41412731f16f3'
end
