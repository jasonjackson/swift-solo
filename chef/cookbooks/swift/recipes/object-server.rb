#
# Cookbook Name:: swift            
# Recipe:: object-server
#
# Copyright 2010, Cloudscaling
#

[:setup, :build, :start].each do |a|

  node[:swift_servers]["object-server"].each do |p,d|
    swift_service "object-server" do
      port p.to_i
      devices d
      action a
    end

    t = resources(:template => "/etc/rsyncd.conf")
    t.variables[:servers]["object" + p.to_s] = d

  end

end

["object-updater","object-replicator","object-auditor"].each do |s|
  swift_init_script s

  service "swift-#{s}" do
    action [ :start, :enable ]
  end
end

