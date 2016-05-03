remote_file node['sax_hadoop']['hadoop_tar_path'] do
   source node['sax_hadoop']['source']
   owner node['sax_hadoop']['owner']
   group node['sax_hadoop']['group']
   mode  node['sax_hadoop']['mode']
   action :create
   notifies :run, 'execute[untar_build]', :immediately
end

execute 'untar_build' do
   command "tar -zxf #{node['sax_hadoop']['hadoop_tar_path']} -C ['sax_hadoop']['hdp_install_loc']"
   action :nothing
   notifies :run, 'execute[remove_build]', :immediately
end

execute 'remove_build' do
   command "rm #{node['sax_hadoop']['hadoop_tar_path']}"
   action :nothing
end

execute 'change_owner' do
   command "chown -R sax:sax #{node['sax_hadoop']['hadoop_untar']}"
   action :run
end

###################################


template "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop/slaves" do
  source "slaves.erb"
  mode node['sax_hadoop']['conf_file_mode']
  variables(
       :master_fqdn=> "#{node['sax_hadoop']['master_fqdn']}",
  )
end


node['sax_hadoop']['slave_fqdn1'].each do |slave|
        execute 'appeding zoo_cfg' do
                command "echo '#{slave}' >> #{node['sax_hadoop']['hadoop_untar']}/etc/hadoop/slaves"
        end
end



template "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  mode node['sax_hadoop']['conf_file_mode']
  variables(
       :rep_value=> "#{node['sax_hadoop']['dfs_replication_value']}",
       :datanode_path=> "#{node['sax_hadoop']['hadoop_untar']}/datanode",
       :namenode_path=> "#{node['sax_hadoop']['hadoop_untar']}/namenode"
  )
end


template "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop/core-site.xml" do
  source "core-site.xml.erb"
  mode node['sax_hadoop']['conf_file_mode']
  variables(
       :master_ip=> "#{node['sax_hadoop']['master_IP_addr']}",
       :core_port=> "#{node['sax_hadoop']['core_port_no']}"
  )
end

template "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop/yarn-site.xml" do
  source "yarn-site.xml.erb"
  mode node['sax_hadoop']['conf_file_mode']
  variables(
       :master_ip=> "#{node['sax_hadoop']['master_IP_addr']}",
       :web_proxy_add_port=> "#{node['sax_hadoop']['web_proxy_add_port']}",
       :resourcemanager_add_port=> "#{node['sax_hadoop']['resourcemanager_add_port']}",
       :resourcemanager_res_tracker_port=> "#{node['sax_hadoop']['resourcemanager_res_tracker_port']}",
       :resourcemanager_sched_add_port=> "#{node['sax_hadoop']['resourcemanager_sched_add_port']}"
  )
end

############################

ruby_block "replace_line_configlines_hadoop" do
block do
  file = Chef::Util::FileEdit.new("#{node['sax_hadoop']['sax_user_path']}.bashrc")
  file.insert_line_if_no_match(/export HADOOP_HOME=#{node['sax_hadoop']['hadoop_untar_bashrc']}/, "export HADOOP_HOME=#{node['sax_hadoop']['hadoop_untar']}")
  file.insert_line_if_no_match(/export PATH=\$PATH:\$HADOOP_HOME\/bin/, "export PATH=$PATH:$HADOOP_HOME/bin")
  file.insert_line_if_no_match(/export PATH=\$PATH:\$HADOOP_HOME\/sbin/,"export PATH=$PATH:$HADOOP_HOME/sbin")
  file.insert_line_if_no_match(/export HADOOP_COMMON_HOME=\$HADOOP_HOME/,"export HADOOP_COMMON_HOME=$HADOOP_HOME")
  file.insert_line_if_no_match(/export HADOOP_MAPRED_HOME=\$HADOOP_HOME/,"export HADOOP_MAPRED_HOME=$HADOOP_HOME")
  file.insert_line_if_no_match(/export HADOOP_HDFS_HOME=\$HADOOP_HOME/,"export HADOOP_HDFS_HOME=$HADOOP_HOME")
  file.insert_line_if_no_match(/export YARN_HOME=\$HADOOP_HOME/,"export YARN_HOME=$HADOOP_HOME")
  file.insert_line_if_no_match(/export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME\/lib\/native"/, "export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib/native\"")
  file.insert_line_if_no_match(/export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME\/lib\/native/, "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native")
file.write_file
end
end

bash 'sourcing bashrc' do
  user node['sax_hadoop']['owner']
  cwd node['sax_hadoop']['sax_user_path']
  code <<-EOH
    sshpass -p sax ssh -o StrictHostKeyChecking=no #{node['sax_hadoop']['username_to_ssh']}@#{node['sax_hadoop']['master_IP_addr']} "cd #{node['sax_hadoop']['sax_user_path']};source .bashrc"
    EOH
end
