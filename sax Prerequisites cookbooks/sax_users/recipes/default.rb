#
# Cookbook Name:: sax_users
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'mixlib/shellout'
  openssl = Mixlib::ShellOut.new("openssl passwd -1 #{node['sax_users']['password']}")
  openssl.run_command
  puts openssl.stdout	


puts node['sax_users']['password']
enc1 = openssl.stdout
enc1 = enc1.sub(/\n/, '')


user "#{node['sax_users']['user']}" do
  supports :manage_home => true
  comment node['sax_users']['user']
  home node['sax_users']['home']
  shell node['sax_users']['shell']
  password enc1
end


execute "sudoers for new_user" do
  command "echo '#{node['sax_users']['user']}    ALL	=(ALL)   ALL' >> /etc/sudoers"
  not_if "grep -F '#{node['sax_users']['user']}	ALL	=(ALL)   ALL' /etc/sudoers"
end

execute "root soft" do
    command "echo       'root soft nofile 1048576' >> #{node['sax_users']['ulimit']}"
    not_if "grep -F     'root soft nofile 1048576' #{node['sax_users']['ulimit']}"
end

execute "root hard" do
    command "echo       'root hard nofile 1048576' >> #{node['sax_users']['ulimit']}"
    not_if "grep -F     'root hard nofile 1048576'  #{node['sax_users']['ulimit']}"

end

execute "user soft" do
    command "echo       '#{node['sax_users']['user']} soft nofile 1048576' >> #{node['sax_users']['ulimit']}"
    not_if "grep -F     '#{node['sax_users']['user']} soft nofile 1048576' #{node['sax_users']['ulimit']}"
end


execute "user hard" do
    command "echo       '#{node['sax_users']['user']} hard nofile 1048576' >> #{node['sax_users']['ulimit']}"
    not_if "grep -F     '#{node['sax_users']['user']} hard nofile 1048576' #{node['sax_users']['ulimit']}"
end

