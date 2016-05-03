#
# Cookbook Name:: pass_ssh
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

host_list = node['pass_ssh']['hosts_list']
host_ip_list = node['pass_ssh']['hosts_ip']
sax_user = node['pass_ssh']['user']

bash 'ssh_on_self' do
  user node['pass_ssh']['user']
  cwd "/home/#{sax_user}"
  code <<-EOH
    ssh-keygen -t rsa -f /home/#{sax_user}/.ssh/id_rsa -q -N ""
    cat /home/#{sax_user}/.ssh/id_rsa.pub >> /home/#{sax_user}/.ssh/authorized_keys
    chmod 600 /home/#{sax_user}/.ssh/authorized_keys
    chmod 700 /home/#{sax_user}/.ssh
    sshpass -p #{node['pass_ssh']['password']} ssh -o StrictHostKeyChecking=no #{node['pass_ssh']['user']}@#{node['fqdn']} "cd /tmp"
  EOH
end

bash 'ssh_on_self' do
  user 'root'
  cwd "/home/#{sax_user}"
  code <<-EOH
   chown -R #{sax_user}:#{sax_user} /home/#{sax_user}/.ssh  
  EOH
end

host_list.each do |host|
	if node['fqdn'] != host
		
		template "/tmp/pass_ssh_scp" do
		  source "pass_ssh_scp.erb"
		  mode 0777
		  variables(
			   :user=> node['pass_ssh']['user'],
			   :ip=> "#{host}",
			   :sourcefile=> "/home/#{sax_user}/.ssh/id_rsa.pub",
			   :destinationpath => "/tmp/authorized_keys",
			   :password=> node['pass_ssh']['password']
		  )
		end
		execute '/tmp/pass_ssh_scp' do
			timeout 100
		end

		bash 'known_hosts' do
			user node['pass_ssh']['user']
	  		cwd "/home/#{sax_user}"
  			code <<-EOH
				sshpass -p #{node['pass_ssh']['password']} ssh -o StrictHostKeyChecking=no #{node['pass_ssh']['user']}@#{host} "mkdir -p ~/.ssh;cat /tmp/authorized_keys >> ~/.ssh/authorized_keys; rm /tmp/authorized_keys"
			  EOH
		end


	end	
end
