#
# Cookbook Name:: swift            
# Recipe:: default
#
# Copyright 2010, Cloudscaling
#

include_recipe "apt"

package "ntp"

%w{curl gcc git-core memcached python-configobj python-coverage python-dev python-nose python-setuptools python-simplejson python-xattr sqlite3 xfsprogs xfsprogs xfsdump acl attr}.each do |pkg_name|
  package pkg_name
end

%w{eventlet webob}.each do |python_pkg|
  easy_install_package python_pkg 
end

user "swift" do
  manage_home true
end

directory "/home/swift" do
  owner "swift"
  group "swift"
end

directory "/var/run/swift" do
  owner "swift"
  group "swift"
  recursive true
  mode 0755
end

template "/etc/rsyncd.conf" do
  source "rsyncd.conf.erb"
  variables(
    :servers => {}
  )
end

cookbook_file "/etc/default/rsync" do
  source "default-rsync"
end

directory "/etc/swift" do
  owner "swift"
  group "swift"
end

directory "/etc/swift/backups" do
  owner "swift"
  group "swift"
end

service "rsync" do
  action :start
  supports :restart => true
  subscribes :restart, resources(:template => "/etc/rsyncd.conf")
end

if(node[:swift][:repository][:url] =~ /git/)
  git "/home/swift/swift" do
    user "swift"
    group "swift"
    reference node[:swift][:repository][:tag]
    repository node[:swift][:repository][:url]
    action :sync
  end
else
  package "bazaar"

  execute "install-swift-bazaar" do
    command "bzr co -r tag:#{node[:swift][:repository][:tag]} lp:swift"
    cwd "/home/swift"
    not_if "test -d /home/swift/swift"
  end
end

execute "python setup.py develop" do
  cwd "/home/swift/swift"
  creates "/usr/local/bin/st"
end

include_recipe "swift::demo_device"

["object-server","account-server","container-server"].each do |server|
  next unless node[:swift_servers] && node[:swift_servers][server]

  include_recipe "swift::#{server}"

end

if(node[:rings])
  node[:rings].each do |t,vals|
    vals.each do |s,w|
      add_ring_node t do
        server s
        weight w
      end
    end

    if(!File.exists?("/etc/swift/#{t}.ring.gz"))
      swift_service "#{t}-server" do
        action :rebalance
      end
    end
  end
end

include_recipe "swift::auth-server"
include_recipe "swift::proxy-server"
