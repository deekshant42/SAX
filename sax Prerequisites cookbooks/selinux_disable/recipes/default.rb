#
# Cookbook Name:: selinux_disable
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

ruby_block "replace_line" do
block do
        file = Chef::Util::FileEdit.new("/etc/sysconfig/selinux")
        file.search_file_replace_line(/SELINUX=enforcing/, "SELINUX=disabled")
        file.write_file
     end
end
