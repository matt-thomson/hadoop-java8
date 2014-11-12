default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '8'
default['java']['oracle']['accept_oracle_download_terms'] = true
default['java']['set_etc_environment'] = true

default['hadoop']['hdfs_site']['dfs.permissions'] = false

default['hadoop']['mapred_site']['mapreduce.framework.name'] = 'yarn'

default['hadoop']['yarn_site']['yarn.application.classpath'] = '/etc/hadoop/conf,/usr/lib/hadoop/*,/usr/lib/hadoop/lib/*,/usr/lib/hadoop-hdfs/*,/usr/lib/hadoop-hdfs/lib/*,/usr/lib/hadoop-mapreduce/*,/usr/lib/hadoop-mapreduce/lib/*,/usr/lib/hadoop-yarn/*,/usr/lib/hadoop-yarn/lib/*'
default['hadoop']['yarn_site']['yarn.nodemanager.aux-services'] = 'mapreduce_shuffle'
default['hadoop']['yarn_site']['yarn.nodemanager.aux-services.mapreduce_shuffle.class'] = 'org.apache.hadoop.mapred.ShuffleHandler'
default['hadoop']['yarn_site']['yarn.scheduler.capacity.resource-calculator'] = 'org.apache.hadoop.yarn.util.resource.DominantResourceCalculator'
default['hadoop']['yarn_site']['yarn.nodemanager.resource.cpu-vcores'] = 1
