require 'serverspec'

# Test that the git repository's directory is properly set up
describe file('/opt/tutorial-a/') do
  it { should be_directory }
  it { should be_grouped_into 'tutorial-a' }
  it { should be_owned_by('tutorial-a') }
end

# Test that the git repository is actually a git repository
describe file('/opt/tutorial-a/.git') do
  it { should be_directory }
  it { should be_grouped_into 'tutorial-a' }
  it { should be_owned_by('tutorial-a') }
end

# Test that the right revision has been checked out
describe file('/opt/tutorial-a/.git/HEAD') do
  its(:content) { should match(/cookbook_test/) }
end

# Test that the git repository's directory is properly set up
describe file('/opt/tutorial-b/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end

# Test that the git repository is actually a git repository
describe file('/opt/tutorial-b/.git') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end

# Test that the right revision has been checked out
describe file('/opt/tutorial-b/.git/HEAD') do
  its(:content) { should match(/django/) }
end
