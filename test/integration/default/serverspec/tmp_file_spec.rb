require 'serverspec'
set :backend, :exec

describe file('/tmp/test') do
  it { should be_file }
end
