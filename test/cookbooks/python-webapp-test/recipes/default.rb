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

include_recipe 'python-webapp'
include_recipe 'yum'

package 'git'

settings_hash = {
  host: 'db.example.com',
  port: '5432',
  username: 'user',
  password: 'pass',
  db_name: 'database',
  secret_key: 'abcd'
}

log 'rinning cookbook'

python_webapp_common 'whats_fresh' do
  create_user true
  path '/opt/whats_fresh'
  owner 'whats_fresh'
  group 'whats_fresh'

  repository 'https://github.com/osu-cass/whats-fresh-api.git'
  revision 'master'

  config_template 'config.yml.erb'
  config_destination '/opt/whats_fresh/config.yml'
  config_vars settings_hash
  requirements_file nil
end
