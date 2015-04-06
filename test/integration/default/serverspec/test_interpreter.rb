require 'serverspec'

# Test that the correct interpreter is installed
describe file('/opt/venv_tutorial_a/bin/python2.7') do
  it { should be_file }
  it { should be_executable }
end

# Test that the correct interpreter is installed
describe file('/opt/venv_tutorial_a/bin/python2.6') do
  it { should be_file }
  it { should be_executable }
end
