require 'serverspec'
set :backend, :exec

# Test that gunicorn is listening on port 8888
describe port(8888) do
  it { should be_listening }
end
