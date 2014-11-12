include_recipe 'java::default'

include_recipe 'hadoop::default'

include_recipe 'hadoop::hadoop_hdfs_namenode'
include_recipe 'hadoop::hadoop_hdfs_datanode'

include_recipe 'hadoop::hadoop_yarn_resourcemanager'
include_recipe 'hadoop::hadoop_yarn_nodemanager'

ruby_block 'format-hdfs' do
  block do
    resources('execute[hdfs-namenode-format]').run_action(:run)
  end
  notifies :create, 'ruby_block[set-hdfs-formatted-flag]', :immediately
  not_if { node.attribute?('hdfs-formatted') }
end

ruby_block 'set-hdfs-formatted-flag' do
  block do
    node.set['hdfs-formatted'] = true
    node.save
  end
  action :nothing
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
