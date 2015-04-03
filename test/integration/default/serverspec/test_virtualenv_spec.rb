require 'serverspec'

# Test that the virtualenv's directory is properly set up
describe file('/opt/venv_whats_fresh/') do
  it { should be_directory }
  it { should be_grouped_into 'whats_fresh' }
  it { should be_owned_by('whats_fresh') }
end

# Test that the virtualenv's directory is properly set up
describe file('/opt/venv_h2o/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end
