include_recipe 'apt'

package 'procps' do
  action :install
end

include_recipe 'java::default'

node.default['hadoop']['hadoop_env']['java_home'] = node['java']['java_home']

include_recipe 'hadoop::default'

include_recipe 'hadoop::hadoop_hdfs_namenode'
include_recipe 'hadoop::hadoop_hdfs_datanode'

include_recipe 'hadoop::hadoop_yarn_resourcemanager'
include_recipe 'hadoop::hadoop_yarn_nodemanager'

marker_file = "#{Chef::Config[:file_cache_path]}/hdfs_formatted"
ruby_block 'format-hdfs' do
  block do
    resources('execute[hdfs-namenode-format]').run_action(:run)
    File.open(marker_file, 'w') {}
  end
  not_if { File.exist? marker_file }
end

ruby_block 'start-namenode' do
  block do
    [:enable, :start].each do |action|
      resources('service[hadoop-hdfs-namenode]').run_action(action)
    end
  end
end

ruby_block 'start-datanode' do
  block do
    [:enable, :start].each do |action|
      resources('service[hadoop-hdfs-datanode]').run_action(action)
    end
  end
end

ruby_block 'create-hdfs-tmpdir' do
  block do
    resources('execute[hdfs-tmpdir]').run_action(:run)
  end
  not_if "hdfs dfs -ls / | grep ' /tmp' | grep -e '^drwxrwxrwt'", :user => 'hdfs'
end

ruby_block 'create-yarn-remote-app-log-dir' do
  block do
    resources('execute[yarn-remote-app-log-dir]').run_action(:run)
  end
  not_if "hdfs dfs -ls /#{node['hadoop']['yarn_site']['yarn-remote-app-log-dir']}", :user => 'hdfs'
end

ruby_block 'start-resourcemanager' do
  block do
    [:enable, :start].each do |action|
      resources('service[hadoop-yarn-resourcemanager]').run_action(action)
    end
  end
end

ruby_block 'start-nodemanager' do
  block do
    [:enable, :start].each do |action|
      resources('service[hadoop-yarn-nodemanager]').run_action(action)
    end
  end
end
