#
# Cookbook Name:: swift            
# Recipe:: proxy-server
#
# Copyright 2010, Cloudscaling
#

include_recipe "swift::account-server"

template "/etc/swift/proxy-server.conf" do
  source "proxy-server.conf.erb"
  owner "swift"
  group "swift"
  variables(
    :use_ssl => node[:swift][:auth_server][:use_ssl]
  )
end

template "/etc/init.d/swift-proxy-server" do
  source "init-script.erb"
  mode 0755
  variables(:server => "proxy-server")
end

service "swift-proxy-server" do
  action [:start, :enable]
  subscribes :restart, resources(:template => "/etc/swift/proxy-server.conf")
end
