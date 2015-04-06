<<<<<<< HEAD
require 'serverspec'

# Test that Tutorial A is running under supervisor
describe service('tutorial_a') do
  it { should be_running.under('supervisor') }
end
||||||| merged common ancestors
=======
require 'serverspec'

# Test that Whats Fresh is running under supervisor
describe service('whats_fresh') do
  it { should be_running.under('supervisor') }
end
>>>>>>> 9422751459aa5b832160096e9e707a0141e49162
