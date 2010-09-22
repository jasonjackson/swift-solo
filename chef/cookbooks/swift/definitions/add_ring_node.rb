#
# Cookbook Name:: swift            
# Definitions:: add_ring_node
#
# Copyright 2010, Cloudscaling
#

define :add_ring_node, :server => nil, :weight => nil do
  server = params[:server]
  weight = params[:weight]
  type = params[:name]

  execute "add-ring-node-#{server}-#{weight}" do
    cwd "/etc/swift"
    command "swift-ring-builder #{type}.builder add #{server} #{weight}"
    notifies :rebalance, resources(:swift_service => "#{type}-server")
    returns 1
    user node[:swift][:user]
    not_if do
      `cd /etc/swift && swift-ring-builder #{type}.builder search #{server}`
      $? == 256   # Why is this 256?  It's what works, but I don't know why.
    end
  end
end
