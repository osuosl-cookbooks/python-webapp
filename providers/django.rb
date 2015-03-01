# FIXME: Should I not use the bash resource?
action :setup do
  bash 'collect_static' do
    only_if { new_resource.collect_static }
    action :run
    code "python #{ new_resource.path }/manage.py collectstatic"
  end
  bash 'migrate' do
    only_if { new_resource.migrate }
    action :run
    code "python #{ new_resource.path }/manage.py migrate"
  end
  new_resource.updated_by_last_action(true)
end
