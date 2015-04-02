require 'serverspec'

# Test that  migrations were run
describe file('/opt/whats_fresh/db.sqlite3') do
  it { should be_file }
end
