#
# Cookbook Name:: swift            
# Recipe:: container-server
#
# Copyright 2010, Cloudscaling
#

[:setup, :build, :start].each do |a|

  node[:swift_servers]["container-server"].each do |p,d|
    swift_service "container-server" do
      port p.to_i
      devices d
      action a
    end

    t = resources(:template => "/etc/rsyncd.conf")
    t.variables[:servers]["container" + p.to_s] = d

  end
end

["container-updater","container-replicator","container-auditor"].each do |s|
  swift_init_script s

  service "swift-#{s}" do
    action [ :start, :enable ]
  end
end

