require 'serverspec'

set :backend, :exec

describe command('hadoop version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /Hadoop 2.4.0/ }
end

describe command('hdfs dfs -ls'), :pending do
    its(:exit_status) { should eq 0 }
end
