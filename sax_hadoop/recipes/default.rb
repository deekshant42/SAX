#
# Cookbook Name:: sax_hadoop
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

hadoop_package_name = ::File.basename(node['sax_hadoop']['source'])
hadoop_extracted_dir = hadoop_package_name.sub(/[.](tar[.]gz|tgz)$/, '')
config_files_mode = '644'

owner = node['sax_hadoop']['owner']
group = node['sax_hadoop']['group']
sax_user = node['sax_hadoop']['username']
user_pwd = node['sax_hadoop']['user_pwd']
install_dir = node['sax_hadoop']['hadoop_install_loc']

hadoop_tar_path = "#{install_dir}/#{hadoop_package_name}"
hadoop_extracted_path = "#{install_dir}/#{hadoop_extracted_dir}"
directory install_dir do
  owner node['sax_hadoop']['owner']
  group node['sax_hadoop']['group']
  mode node['sax_hadoop']['mode']
  action :create
end


remote_file hadoop_tar_path do
   source node['sax_hadoop']['source']
   owner node['sax_hadoop']['owner']
   group node['sax_hadoop']['group']
   mode  node['sax_hadoop']['mode']
   action :create
   notifies :run, 'execute[untar_hadoop_build]', :immediately
end

execute 'untar_hadoop_build' do
   command "tar -zxf #{hadoop_tar_path} -C #{install_dir}" 
   action :nothing
   notifies :run, 'execute[remove_hadoop_build]', :immediately
end

execute 'remove_hadoop_build' do
   command "rm #{hadoop_tar_path}"
   action :nothing
end

execute 'change_owner_hadoop' do
   command "chown -R #{owner}:#{group} #{hadoop_extracted_path}"
end

#################### SLAVES ###################################


template "#{hadoop_extracted_path}/etc/hadoop/slaves" do
  source "slaves.erb"
  mode config_files_mode
end

node['sax_hadoop']['slaves_fqdn'].each do |slave|
        execute 'appeding slaves' do
                command "echo '#{slave}' >> #{hadoop_extracted_path}/etc/hadoop/slaves"
		not_if slave == node['sax_hadoop']['master_fqdn']
        end
end

#################### HDFS-SITE ###################################

template "#{hadoop_extracted_path}/etc/hadoop/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  mode config_files_mode
  variables(
       :rep_value=> "#{node['sax_hadoop']['dfs_replication_value']}",
       :datanode_path=> "#{hadoop_extracted_path}/datanode",
       :namenode_path=> "#{hadoop_extracted_path}/namenode",
       :name_sec_http_addrs=> "#{node['sax_hadoop']['master_fqdn']}"
  )
end

#################### CORE-SITE ###################################

template "#{hadoop_extracted_path}/etc/hadoop/core-site.xml" do
  source "core-site.xml.erb"
  mode config_files_mode
  variables(
#      :hdp_tmp_dir_path=> "#{node['sax_hadoop']['hadoop_untar']}/hadooptmp/",
       :master_ip=> "#{node['sax_hadoop']['master_fqdn']}",
       :core_port=> "#{node['sax_hadoop']['core_port_no']}"
  )
end

#################### YARN-SITE ###################################

template "#{hadoop_extracted_path}/etc/hadoop/yarn-site.xml" do
  source "yarn-site.xml.erb"
  mode config_files_mode
  variables(
#      :hdp_tmp_dir_path=> "#{node['sax_hadoop']['hadoop_untar']}/hadooptmp/",
       :master_ip=> "#{node['sax_hadoop']['master_fqdn']}",
       :web_proxy_add_port=> "#{node['sax_hadoop']['web_proxy_add_port']}",
       :resourcemanager_add_port=> "#{node['sax_hadoop']['resourcemanager_add_port']}",
       :resourcemanager_res_tracker_port=> "#{node['sax_hadoop']['resourcemanager_res_tracker_port']}",
       :resourcemanager_sched_add_port=> "#{node['sax_hadoop']['resourcemanager_sched_add_port']}"
  )
end


if node['fqdn'] == node['sax_hadoop']['master_fqdn'] then
	directory "#{hadoop_extracted_path}/namenode" do
  	owner node['sax_hadoop']['owner']
  	group node['sax_hadoop']['group']
  	mode node['sax_hadoop']['mode']
  	action :create
	end
end

if node['fqdn'] != node['sax_hadoop']['master_fqdn'] then
	directory "#{hadoop_extracted_path}/datanode" do
  	owner node['sax_hadoop']['owner']
  	group node['sax_hadoop']['group']
  	mode node['sax_hadoop']['mode']
  	action :create
	end
end

ruby_block "replace_line_configlines_hadoop" do
block do
  file = Chef::Util::FileEdit.new("/home/#{sax_user}/.bashrc")
  file.insert_line_if_no_match(/export HADOOP_HOME=\#{hadoop_extracted_path}/, "export HADOOP_HOME=#{hadoop_extracted_path}")
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
  cwd '/tmp'
  code <<-EOH
    sshpass -p #{user_pwd} ssh -o StrictHostKeyChecking=no #{node['sax_hadoop']['username']}@#{node['fqdn']} "cd /home/#{sax_user};source .bashrc"
    EOH
end





#bash 'namenode format' do
#  user node['sax_hadoop']['owner']
#  cwd "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop"
#  code <<-EOH
#    sshpass -p sax ssh -o StrictHostKeyChecking=no sax@#{node['sax_hadoop']['master_fqdn']} "cd #{node['sax_hadoop']['hadoop_untar']}/hadoop;hdfs namenode -format -force"
#    EOH
#end

#bash 'namenode format' do
#  user node['sax_hadoop']['owner']
#  cwd "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop"
#  code <<-EOH
#    sshpass -p #{user_pwd} ssh -o StrictHostKeyChecking=no sax@#{node['sax_hadoop']['master_fqdn']} "cd #{node['sax_hadoop']['hadoop_untar']}/sbin;start-all.sh"
#    EOH
#end

