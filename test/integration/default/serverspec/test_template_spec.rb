require 'serverspec'
set :backend, :exec

# Check that the configuration file is properly set up with default values
describe file('/opt/tutorial_a/config/config.yml') do
  it { should be_grouped_into 'tutorial_a' }
  it { should be_owned_by('tutorial_a') }
end

# Check that the configuration file is properly set up with default values
describe file('/opt/tutorial_b/settings.py') do
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end
