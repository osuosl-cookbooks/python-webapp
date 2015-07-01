require 'serverspec'
set :backend, :exec

# Test that Tutorial A is running under supervisor
describe service('tutorial_a') do
  it { should be_running.under('supervisor') }
end
