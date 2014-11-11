include_recipe 'java::default'

include_recipe 'hadoop::default'
include_recipe 'hadoop::hadoop_hdfs_namenode'
include_recipe 'hadoop::hadoop_hdfs_datanode'

ruby_block 'format-hdfs' do
  block do
    resources('execute[hdfs-namenode-format]').run_action(:run)
    node.set['hdfs-formatted'] = true
    node.save
  end
  not_if { node.attribute?('hdfs-formatted') }
end

ruby_block 'start-namenode' do
  block do
    %w(enable start).each do |action|
      resources('service[hadoop-hdfs-namenode]').run_action(action.to_sym)
    end
  end
end

ruby_block 'start-datanode' do
  block do
    %w(enable start).each do |action|
      resources('service[hadoop-hdfs-datanode]').run_action(action.to_sym)
    end
  end
end
