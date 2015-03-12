require 'serverspec'

# Test that the git repository's directory is properly set up
describe file('/opt/app/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_readable.by('chef') }
end

# Test that the git repository is actually a git repository
describe file('/opt/app/.git') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_readable.by('chef') }
end

# Test that the right revision has been checked out
describe file('/opt/app/.git/HEAD') do
  its(:content) { should match(/master/) }
end
