require 'serverspec'

# Test that Whats Fresh is running under supervisor
describe service('whats_fresh') do
  it { should be_running.under('supervisor') }
end
