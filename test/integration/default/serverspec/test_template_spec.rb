require 'serverspec'

# Check that the configuration file is properly set up with default values
describe file('/opt/app/settings.py') do
  it { should be_grouped_into 'chef' }
  it { should be_readable.by('chef') }
  it { should be_readable.by('chef') }
end
