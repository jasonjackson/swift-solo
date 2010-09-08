#
# Cookbook Name:: apt
# Recipe:: python_software_properties
#
# Copyright 2010, Cloudscaling
#

include_recipe "apt"

package "python-software-properties"

execute "add-apt-repository ppa:swift-core/ppa" do
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

