#
# Cookbook Name:: swift            
# Recipe:: ssl-certificates
#
# Copyright 2010, Cloudscaling
#

cookbook_file "/etc/swift/cert.pem" do
  source "cert.pem"
  owner "swift"
  group "swift"
  mode 0644
end

cookbook_file "/etc/swift/key.pem" do
  source "key.pem"
  owner "swift"
  group "swift"
  mode 0400
end
