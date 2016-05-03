#
# Cookbook Name:: sax_prerequisites
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "sax_os_packages"
include_recipe "firewall_disable"
include_recipe "selinux_disable"
include_recipe "default_requiretty"
include_recipe "sax_users"
include_recipe "install_java"

