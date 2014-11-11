include_recipe 'java::default'

include_recipe 'hadoop::default'
include_recipe 'hadoop::hadoop_hdfs_namenode'
include_recipe 'hadoop::hadoop_hdfs_datanode'

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

execute 'set-hdfs-permissions' do
  user 'hdfs'
  command 'hdfs dfs -chmod 777 /'
  notifies :create, 'ruby_block[set-hdfs-permissions-flag]', :immediately
  not_if { node.attribute?('hdfs-permissions-set') }
end

ruby_block 'set-hdfs-permissions-flag' do
  block do
    node.set['hdfs-permissions-set'] = true
    node.save
  end
  action :nothing
end
