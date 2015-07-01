require 'serverspec'
set :backend, :exec

# Test that  migrations were run
describe file('/opt/tutorial_a/source/db.sqlite3') do
  it { should be_file }
end
