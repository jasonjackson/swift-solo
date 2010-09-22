#
# Cookbook Name:: swift            
# Attributes:: swift
#
# Copyright 2010, Cloudscaling
#

default[:swift][:user] = "swift"
default[:swift][:auth_server][:super_admin_key] = "devauth"

default[:swift][:proxy_server][:use_ssl] = false
default[:swift][:auth_server][:use_ssl] = false

if(node[:ec2])
  default[:swift][:proxy_server][:hostname] = node[:ec2][:public_hostname]
else
  default[:swift][:proxy_server][:hostname] = "127.0.0.1"
end

# For git checkouts
#default[:swift][:repository][:url] = "http://github.com/openstack/swift.git"
#default[:swift][:repository][:tag] = "1.0.2"

# For bzr checkouts
default[:swift][:repository][:url] = "lp:swift" # For bzr checkouts
#default[:swift][:repository][:tag] = "revno:58" # For bzr checkous
