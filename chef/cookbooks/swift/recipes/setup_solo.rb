#
# Cookbook Name:: swift            
# Recipe:: default
#
# Copyright 2010, Cloudscaling
#

include_recipe "apt::python_software_properties"

%w{curl
   gcc
   rsync 
   memcached
   python-configobj
   python-coverage
   python-dev
   python-nose
   python-setuptools
   python-simplejson
   python-xattr
   python-webob
   python-eventlet
   python-greenlet
   python-pastedeploy 
   sqlite3
   xfsprogs
   xfsdump
   acl
   attr}.each do |pkg_name|
  package pkg_name
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

directory "/etc/swift" do
  owner "swift"
  group "swift"
end

directory "/etc/swift/backups" do
  owner "swift"
  group "swift"
end

include_recipe "swift::configure_rsync"
include_recipe "swift::install"

if node[:swift][:demo_device]  
  dev = node[:swift][:demo_device]
else
  dev = "loop0"
  #make a loopback device
  loopback_file "demo_device" do
    backing_file "/tmp/swift"
    device dev 
  end
end  

build_xfs "xfs_loopback" do
  device dev
end

mnt_dir = "/mnt/sdb1"

directory mnt_dir do 
  mode "0755"
  owner "root"
  group "root"
end

execute "update fstab" do
  command "echo '/dev/#{dev} #{mnt_dir} xfs noauto,noatime,nodiratime,nobarrier,logbufs=8 0 0' >> /etc/fstab"
  not_if "grep '/dev/#{dev}' /etc/fstab"
end

execute "mount #{mnt_dir}" do
  not_if "df | grep /dev/#{dev}"
end

directory "/srv" do
  owner "swift"
  group "swift"
end

directory "#{mnt_dir}/test" do
  owner "swift"
  group "swift"
end


%w{1 2 3 4}.each do |n|
  d = "#{mnt_dir}/#{n}"
  l = "/srv/#{n}" 

  directory d do
    owner "swift"
    group "swift"
  end
  
  link l do
    to d
  end
 
  directory "#{l}/node" do
    owner "swift"
    group "swift"
  end

  directory "#{l}/node/#{n}" do
    owner "swift"
    group "swift"
  end
end

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
