template '/etc/bootstrap.sh' do
  source 'bootstrap.sh.erb'
  mode '0755'
end

ruby_block 'stop-resourcemanager' do
  block do
    resources('service[hadoop-yarn-resourcemanager]').run_action(:stop)
  end
end

ruby_block 'stop-nodemanager' do
  block do
    resources('service[hadoop-yarn-nodemanager]').run_action(:stop)
  end
end

ruby_block 'stop-datanode' do
  block do
    resources('service[hadoop-hdfs-datanode]').run_action(:stop)
  end
end

ruby_block 'stop-namenode' do
  block do
    resources('service[hadoop-hdfs-namenode]').run_action(:stop)
  end
end

node.default['hadoop']['core_site']['fs.defaultFS'] = 'hdfs://HOSTNAME'
node.default['hadoop']['yarn_site']['yarn.resourcemanager.hostname'] = 'HOSTNAME'

include_recipe 'hadoop::default'
