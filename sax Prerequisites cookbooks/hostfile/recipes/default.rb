#
# Cookbook Name:: hostfile
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#i
#
#

#arr2 = arr.map do |e| e.dup end


ips = node['hostfile']['ipaddresses']
fqdns = node['hostfile']['hostnames']
length1 = ips.length
#aliases1 = fqdns.map do |e| e.dup end
sax_pwd = node['hostfile']['user_pwd']
node_ip = node['ipaddress']

script 'extract_module' do
  interpreter "bash"
   user 'root'
   cwd '/etc' 
  code <<-EOH
    cp /etc/hosts /etc/hosts_backup
    EOH
end

#array = ['a', 'b', 'c']
#hash = Hash[array.map.with_index.to_a]    # => {"a"=>0, "b"=>1, "c"=>2}
#hash['b'] # => 1

ips.each do |ip|
	hash = Hash[ips.map.with_index.to_a]
	index = hash[ip]
#	fqdns[index] << ".impetus.co.in"
	
	
		hostsfile_entry ip do
		  hostname  fqdns[index]
		#  aliases   [aliases1[index]]
		  unique    true
		  action    :create_if_missing
		end
end

#hash1 = Hash[ips.map.with_index.to_a]
# index1 = hash1[node_ip]
#node_fqdn = fqdns[index1] 
 
execute 'setting hostname' do
	command 'echo #{sax_pwd}|sudo -S hostname #{node_fqdn}'
end

#hostsfile_entry '2.3.4.5' do
 # hostname  'dummi'
  #aliases   ['dummi.impetus.co.in']
  #unique    true
  #action    :create_if_missing
#end

