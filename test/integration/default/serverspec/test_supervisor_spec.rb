require 'serverspec'

# Test that Tutorial A is running under supervisor
describe service('tutorial_a') do
  it { should be_running.under('supervisor') }
end
