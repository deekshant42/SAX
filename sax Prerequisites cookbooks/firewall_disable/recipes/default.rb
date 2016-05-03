#
# Cookbook Name:: firewall_disable
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


service "iptables" do
        action [:disable, :stop]
end
