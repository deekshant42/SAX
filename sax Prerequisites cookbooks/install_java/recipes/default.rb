#Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)


directory node['install_java']['install_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file node['install_java']['java_tar_path'] do
   source node['install_java']['source']
   owner node['install_java']['owner']
   group node['install_java']['group']
   mode node['install_java']['mode']
   action :create
   notifies :run, 'execute[untar_build]', :immediately
end

execute 'untar_build' do
   command "tar -zxf #{node['install_java']['java_tar_path']} -C #{node['install_java']['install_path']}" #/usr/lib/jvm
   action :nothing
   notifies :run, 'execute[remove_build]', :immediately
end


execute 'remove_build' do
   command "rm #{node['install_java']['java_tar_path']}"
   action :nothing
end


directory node['install_java']['java_home'] do
owner node['install_java']['owner']
group node['install_java']['group']
mode node['install_java']['mode']
end


#execute 'append_java_path' do
#   command "echo \"export JAVA_HOME=#{node['install_java']['java_home']}\" >> #{node['install_java']['java_path']}"
#   not_if "grep -F 'export JAVA_HOME=#{node['install_java']['java_home']}' #{node['install_java']['java_path']}"
#end



ruby_block "update profile" do
  block do
    fe = Chef::Util::FileEdit.new("#{node['install_java']['java_path']}")
    fe.insert_line_if_no_match(/export JAVA_HOME=#{node['install_java']['java_home']}/,"export JAVA_HOME=#{node['install_java']['java_home']}")
    fe.insert_line_if_no_match(/export PATH=\$JAVA_HOME\/bin:\$PATH/,"export PATH=\$JAVA_HOME/bin:\$PATH") 
    fe.write_file
  end
end


ruby_block "update profile" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/profile")
    fe.insert_line_if_no_match(/export JAVA_HOME=#{node['install_java']['java_home']}/,"export JAVA_HOME=#{node['install_java']['java_home']}")
    fe.insert_line_if_no_match(/export PATH=\$JAVA_HOME\/bin:\$PATH/,"export PATH=\$JAVA_HOME/bin:\$PATH") 
    fe.write_file
  end
end


bash 'sourcing JAVA path' do
  user node['install_java']['owner']
  cwd node['install_java']['home_path']
  code <<-EOH
  sshpass -p #{node['install_java']['pwd']} ssh -o StrictHostKeyChecking=no #{node['install_java']['username_for_ssh']}@#{node['install_java']['ip_to_source']} "cd #{node['install_java']['home_path']};source .bashrc"
  EOH
end

bash 'sourcing JAVA path' do
  user node['install_java']['owner']
  cwd node['install_java']['home_path']
  code <<-EOH
  sshpass -p #{node['install_java']['pwd']} ssh -o StrictHostKeyChecking=no #{node['install_java']['username_for_ssh']}@#{node['install_java']['ip_to_source']} "cd /etc;source profile"
  EOH
end
