require 'serverspec'

# Check that the configuration file is properly set up with default values
describe file('/opt/whats_fresh/whats_fresh/settings.py') do
  it { should be_grouped_into 'whats_fresh' }
  it { should be_owned_by('whats_fresh') }
end
