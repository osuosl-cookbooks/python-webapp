require 'serverspec'

# Check that the configuration file is properly set up with default values
describe file('/opt/tutorial-a/config.yml') do
  it { should be_grouped_into 'tutorial-a' }
  it { should be_owned_by('tutorial-a') }
end

# Check that the configuration file is properly set up with default values
describe file('/app/tutorial-b/settings.py') do
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end
