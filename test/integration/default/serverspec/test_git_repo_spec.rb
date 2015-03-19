require 'serverspec'

# Test that the git repository's directory is properly set up
describe file('/opt/whats_fresh/') do
  it { should be_directory }
  it { should be_grouped_into 'whats_fresh' }
  it { should be_owned_by('whats_fresh') }
end

# Test that the git repository is actually a git repository
describe file('/opt/whats_fresh/.git') do
  it { should be_directory }
  it { should be_grouped_into 'whats_fresh' }
  it { should be_owned_by('whats_fresh') }
end

# Test that the right revision has been checked out
describe file('/opt/whats_fresh/.git/HEAD') do
  its(:content) { should match(/master/) }
end

# Test that the git repository's directory is properly set up
describe file('/opt/working_h2ofronts/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end

# Test that the git repository is actually a git repository
describe file('/opt/working_h2ofronts/.git') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end

# Test that the right revision has been checked out
describe file('/opt/working_h2ofronts/.git/HEAD') do
  its(:content) { should match(/eb41412731f16f3/) }
end
