require 'serverspec'
set :backend, :exec

# Test that the directory for image files was created
describe file('/opt/tutorial_a/static_files/img') do
  it { should be_directory }
end

# Test that the directory for css files was created
describe file('/opt/tutorial_a/static_files/css') do
  it { should be_directory }
end

# Test that the directory for javascript files was created
describe file('/opt/tutorial_a/static_files/js') do
  it { should be_directory }
end
