#
# Cookbook Name:: swift            
# Definition:: loopback 
#
# Copyright 2010, Cloudscaling
#

define :loopback_file, :backing_file => "/tmp/temp", :device => "loop0" do
  backing_file = params[:backing_file]
  device = params[:device] 

  execute "make-file-for-device" do
    command "dd if=/dev/zero of=#{backing_file} bs=1024 count=2048000" 
    not_if { File.exists?(backing_file) }
  end
  
  execute "associate-loopback" do
    command "losetup /dev/#{device} #{backing_file}" 
    not_if { `losetup /dev/#{device}`.match(backing_file) } 
  end
end  
