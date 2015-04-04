require 'serverspec'

# Test that  migrations were run
describe file('/opt/tutorial-a/db.sqlite3') do
  it { should be_file }
end
