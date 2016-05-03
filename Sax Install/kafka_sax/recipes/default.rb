#
# Cookbook Name:: kafka_sax
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
kafka_package_name = ::File.basename(node['kafka_sax']['source'])
kafka_extracted_dir = kafka_package_name.sub(/[.](tar[.]gz|tgz)$/, '')
sax_user = node['kafka_sax']['owner']
install_dir = node['kafka_sax']['install_path']

kafka_conf_dir = "#{install_dir}/#{kafka_extracted_dir}/config"

kafka_properties_file_path = "#{kafka_conf_dir}/server.properties"

host = node['kafka_sax']['hostname']

zk_hosts_kafka = ''

zk_hosts_taken = node['kafka_sax']['zk_ip']

size1 = zk_hosts_taken.length
index = 1

zk_hosts_taken.each do |host_zk|
	zk_hosts_kafka << host_zk
	zk_hosts_kafka << ':2181'
	if index < size1
		zk_hosts_kafka << ','
		index = index + 1
	end
end

# creating the install directory if missing
directory install_dir do
  owner node['kafka_sax']['owner']
  group node['kafka_sax']['group']
  mode node['kafka_sax']['mode']
  action :create
end

# Fetching zookeeper tar.gz file from remote location
remote_file "#{install_dir}/#{kafka_package_name}" do
        source node['kafka_sax']['source']
        owner node['kafka_sax']['owner']
        group node['kafka_sax']['group']
        mode node['kafka_sax']['mode']
        action :create
# If above lines runs successfully then calling install_kafka script resource
               notifies :run, 'script[install_kafka]', :immediately
end

# Installing the tarball
script 'install_kafka' do
  interpreter 'bash'
  user 'root'
  code <<-EOL
    tar zxf #{install_dir}/#{kafka_package_name} -C #{install_dir}
    rm -f #{install_dir}/#{kafka_package_name}
    chown -R #{sax_user}:#{sax_user} #{install_dir}/#{kafka_extracted_dir}
  EOL
  not_if {::File.exist?("#{install_dir}/#{kafka_extracted_dir}")}
  action :nothing
end

# Create kafka logs directory
directory "#{install_dir}/#{kafka_extracted_dir}/kafka-logs" do
  owner node['kafka_sax']['owner']
  group node['kafka_sax']['group']
  mode node['kafka_sax']['mode']
  action :create
end

puts node['kafka_sax']['zk_ip']

ruby_block "editing_server.properties" do
block do 
   file = Chef::Util::FileEdit.new("#{kafka_properties_file_path}")
  file.search_file_replace_line(/log.dirs=\/tmp\/kafka-logs/, "log.dirs=#{install_dir}/#{kafka_extracted_dir}/kafka-logs")
  file.search_file_replace_line(/zookeeper.connect=localhost:2181/, "zookeeper.connect=#{zk_hosts_kafka}")
  file.write_file
end
end

#Starting the kafka if it is not running
script 'start_kafka' do
        interpreter 'bash'
        user 'sax'
        cwd '/tmp'
        code <<-EOL
				sshpass -p #{node['kafka_sax']['password']} scp -r #{install_dir}/#{kafka_extracted_dir} #{sax_user}@#{host}:#{install_dir}/
				rm -rf #{install_dir}/#{kafka_extracted_dir}
                sshpass -p #{node['kafka_sax']['password']} ssh -o StrictHostKeyChecking=no #{sax_user}@#{host} "cd #{install_dir}/#{kafka_extracted_dir}/bin;nohup ./kafka-server-start.sh ../config/server.properties </dev/null &>/dev/null &"
        EOL
end
