#
# Cookbook Name:: python-cloudfiles
# Recipe:: default
#
# Copyright 2010, Cloudscaling
#

execute "install_cloudfiles" do
  command "python setup.py install"
  cwd "/tmp/python-cloudfiles"
  creates "/usr/local/lib/python2.6/dist-packages/cloudfiles"
  action :nothing
end

git "/tmp/python-cloudfiles" do
  repository node[:python_cloudfiles][:repo][:url]
  action :sync
  notifies :run, resources(:execute => "install_cloudfiles")
end


