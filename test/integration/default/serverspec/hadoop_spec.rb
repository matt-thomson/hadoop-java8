require 'serverspec'

set :backend, :exec

describe command('hadoop version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /Hadoop 2.4.0/ }
end

describe command('hdfs dfs -ls /') do
    its(:exit_status) { should eq 0 }
end

describe command('hdfs dfs -cat test') do
    let(:pre_command) { 'echo abc123 | hdfs dfs -put -f - test' }

    its(:exit_status) { should eq 0 }
    its(:stdout) { should eq "abc123\n" }
end

describe command('hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 2 1000') do
	its(:exit_status) { should eq 0 }
    its(:stdout) { should match /Estimated value of Pi is 3.14/ }
end
