require 'serverspec'

# Check that the configuration file is properly set up with default values
describe file('/opt/whats_fresh/config.yml') do
  it { should be_grouped_into 'whats_fresh' }
  it { should be_owned_by('whats_fresh') }
end

# Check that the configuration file is properly set up with default values
describe file('/opt/working_h2ofronts/settings.py') do
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end
