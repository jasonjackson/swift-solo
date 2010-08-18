#
# Cookbook Name:: swift            
# Recipe:: demo_device
#
# Copyright 2010, Cloudscaling
#

execute "build-demo-swift-device" do
  command "dd if=/dev/zero of=/tmp/swift bs=1024 count=2048000" 
  not_if { File.exists?("/tmp/swift") }
end

execute "associate-swift-loopback" do
  command "losetup /dev/loop0 /tmp/swift" 
  not_if { `losetup /dev/loop0` =~ /swift/ }
end

execute "build-swift-fs" do
  command "mkfs.xfs -i size=1024 /dev/loop0"
  not_if 'xfs_admin -u /dev/loop0'
end

directory "/mnt/sdb1" do 
  mode "0755"
  owner "root"
  group "root"
end

execute "update fstab" do
  command "echo '/dev/loop0 /mnt/sdb1 xfs noauto,noatime,nodiratime,nobarrier,logbufs=8 0 0' >> /etc/fstab"
  not_if "grep '/dev/loop0' /etc/fstab"
end

execute "mount /mnt/sdb1" do
  not_if "df | grep /dev/loop0"
end
