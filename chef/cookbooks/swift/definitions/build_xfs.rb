#
# Cookbook Name:: swift            
# Definition:: build xfs 
#
# Copyright 2010, Cloudscaling
#

define :build_xfs, :device => nil, :size => 1024 do
  device = params[:device]
  size = params[:size]

  execute "build-fs" do
    command "mkfs.xfs -i size=#{size} /dev/#{device}"
    not_if "xfs_admin -u /dev/#{device}"
  end
end
