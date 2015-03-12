require 'serverspec'

# Test that the virtualenv's directory is properly set up
describe file('/opt/venv/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_readable.by('chef') }
end
