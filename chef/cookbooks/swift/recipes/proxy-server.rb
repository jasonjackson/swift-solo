#
# Cookbook Name:: swift            
# Recipe:: proxy-server
#
# Copyright 2010, Cloudscaling
#

include_recipe "swift::account-server"

template "/etc/swift/proxy-server.conf" do
  source "proxy-server.conf.erb"
  owner node[:swift][:user]
  group node[:swift][:user]
  variables(
    :use_ssl => node[:swift][:auth_server][:use_ssl]
  )
end

swift_init_script "proxy-server"

service "swift-proxy-server" do
  action [:start, :enable]
  subscribes :restart, resources(:template => "/etc/swift/proxy-server.conf")
end
