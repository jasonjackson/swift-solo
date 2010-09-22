#
# Cookbook Name:: swift            
# Definitions:: init_script 
#
# Copyright 2010, Cloudscaling
#

define :swift_init_script do
  template "/etc/init.d/swift-#{params[:name]}" do
    source "init-script.erb"
    mode 0755
    variables(
        :server => params[:name],
        :user => node[:swift][:user]
    )
  end
end

