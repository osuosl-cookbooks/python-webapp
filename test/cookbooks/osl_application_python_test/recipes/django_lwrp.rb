#
# Cookbook Name:: osl_application_python_test
# Recipe:: django_lwrp
#
# Copyright 2015 OSU Open Source Lab
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

application 'test_defaults' do
  path '/opt/test_defaults'
  owner 'root'
  group 'root'
  repository node['whats_fresh']['repository']
  revision 'master'
  migrate true

  django do
    subdirectory 'test_django'
  end
end

application 'test_settings' do
  path '/opt/test_settings'
  owner 'root'
  group 'root'
  repository node['whats_fresh']['repository']
  revision 'master'
  migrate false

  django do
    local_settings_file 'config.yml'
    settings_template 'config_light.yml.erb'
    subdirectory 'test_django'
    collectstatic false
  end
end

settings_hash = { 'item1' => 'val1', 'item2' => 'val2' }

application 'test_options' do
  path '/opt/test_options'
  owner 'root'
  group 'root'
  repository node['whats_fresh']['repository']
  revision 'master'
  migrate false

  django do
    local_settings_file 'config.yml'
    packages ['twisted']
    requirements 'special_requirements.txt'
    settings_template 'config.yml.erb'
    settings settings_hash
    database do
      name 'test_db'
      adapter 'django.contrib.gis.db.backends.postgis'
      username 'test_user'
      host 'localhost'
      password 'test_password'
      port '5432'
    end
    debug true
    subdirectory 'test_django'
    # a custom_collectstatic is defined in the test app
    collectstatic 'custom_collectstatic'
  end
end
