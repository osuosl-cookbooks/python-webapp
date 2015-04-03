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

python_webapp 'pgd' do
  path nil
  requirements_file 'special_requirements.txt'

  django_migrate false
  django_collectstatic false

  repository 'https://github.com/osuosl/python-test-apps.git'

  config_template nil
  revision 'cookbook_test' # TODO: set this to nil
end
