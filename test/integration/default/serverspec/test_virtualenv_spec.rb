require 'serverspec'

# Test that the virtualenv's directory is properly set up
describe file('/opt/venv/') do
  it { should be_directory }
  it { should be_grouped_into 'whats_fresh' }
  it { should be_owned_by('whats_fresh') }
end

# Test that the virtualenv's directory is properly set up
describe file('/opt/venv_h2o/') do
  it { should be_directory }
  it { should be_grouped_into 'working_waterfronts' }
  it { should be_owned_by('working_waterfronts') }
end
