require 'serverspec'

set :backend, :exec

describe command('java -version') do
	its(:exit_status) { should eq 0 }
	its(:stdout) { should match /1.8.0/ }
end
