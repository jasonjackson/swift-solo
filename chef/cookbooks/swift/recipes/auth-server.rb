#
# Cookbook Name:: swift            
# Recipe:: auth-server
#
# Copyright 2010, Cloudscaling
#

include_recipe "swift::account-server"
include_recipe "swift::ssl-certificates"

template "/etc/swift/auth-server.conf" do
  source "auth-server.conf.erb"
  owner node[:swift][:user]
  group node[:swift][:user]
  variables(
    :use_ssl => node[:swift][:auth_server][:use_ssl],
    :hostname => node[:swift][:proxy_server][:hostname],
    :super_admin_key => node[:swift][:auth_server][:super_admin_key]
  )
end

swift_init_script "auth-server"

service "swift-auth-server" do
  action [:start, :enable]
  subscribes :restart, resources(:template => "/etc/swift/auth-server.conf")
end

