


File.open('/tmp/test.txt') do|file|
    node.override['default_requiretty']['my_attribute'] = file.read(34)
           
           

user "#{node['default_requiretty']['user']}" do
  supports :manage_home => true
  comment node['default_requiretty']['comment']
  home node['default_requiretty']['home']
  shell node['default_requiretty']['shell']
  password node['default_requiretty']['my_attribute']
end
           


execute "sudoers for new_user" do
  command "echo '#{node['default_requiretty']['user']}    ALL=(ALL:ALL)   ALL' >> /etc/sudoers"
  not_if "grep -F '#{node['default_requiretty']['user']}  ALL=(ALL:ALL)   ALL' /etc/sudoers"
end

execute "root soft" do
    command "echo       'root soft nofile 1048576' >> #{node['default_requiretty']['ulimit']}"
    not_if "grep -F     'root soft nofile 1048576' #{node['default_requiretty']['ulimit']}"
end

execute "root hard" do
    command "echo       'root hard nofile 1048576' >> #{node['default_requiretty']['ulimit']}"
    not_if "grep -F     'root hard nofile 1048576'  #{node['default_requiretty']['ulimit']}"

end

execute "user soft" do
    command "echo       '#{node['default_requiretty']['user']} soft nofile 1048576' >> #{node['default_requiretty']['ulimit']}"
    not_if "grep -F     '#{node['default_requiretty']['user']} soft nofile 1048576' #{node['default_requiretty']['ulimit']}"
end

execute "user hard" do
    command "echo       '#{node['default_requiretty']['user']} hard nofile 1048576' >> #{node['default_requiretty']['ulimit']}"
    not_if "grep -F     '#{node['default_requiretty']['user']} hard nofile 1048576' #{node['default_requiretty']['ulimit']}"
end

