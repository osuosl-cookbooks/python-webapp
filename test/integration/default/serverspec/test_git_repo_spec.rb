require 'serverspec'

# Test that the git repository's directory is properly set up
describe file('/opt/tutorial_a/source') do
  it { should be_directory }
  it { should be_grouped_into 'tutorial_a' }
  it { should be_owned_by('tutorial_a') }
end

# Test that the git repository is actually a git repository
describe file('/opt/tutorial_a/source/.git') do
  it { should be_directory }
  it { should be_grouped_into 'tutorial_a' }
  it { should be_owned_by('tutorial_a') }
end

# Test that the right revision has been checked out
describe command('cd /opt/tutorial_a/source/ && '\
  'diff <(git rev-parse HEAD) <(git rev-parse origin/cookbook_test)') do
  its(:stdout) { should match '' }
end

# Test that the git repository's directory is properly set up
describe file('/opt/tutorial_b/') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end

# Test that the git repository is actually a git repository
describe file('/opt/tutorial_b/source/.git') do
  it { should be_directory }
  it { should be_grouped_into 'chef' }
  it { should be_owned_by('chef') }
end

# Test that the right revision has been checked out
describe command('cd /opt/tutorial_b/source/ && '\
  'diff <(git rev-parse HEAD) <(git rev-parse origin/django)') do
  its(:stdout) { should match '' }
end
