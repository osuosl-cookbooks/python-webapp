require 'serverspec'
set :backend, :exec

# Test that the virtualenv's directory is properly set up
describe file('/opt/tutorial_a/venv') do
  it { should be_directory }
  it { should be_grouped_into 'tutorial_a' }
  it { should be_owned_by('tutorial_a') }
end

# Test that the virtualenv's directory is properly set up
describe file('/opt/venv_h2o/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end
