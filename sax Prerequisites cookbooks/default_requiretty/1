#
# Cookbook Name:: default_requiretty
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


#To comment
ruby_block "replace_line" do
block do
  file = Chef::Util::FileEdit.new("/etc/sudoers")
  file.search_file_replace_line(/Defaults    requiretty/, "#Defaults    requiretty")
  file.write_file
end
end

