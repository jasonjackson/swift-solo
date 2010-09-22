#
# Cookbook Name:: swift
# Recipe:: account-server
#
# Copyright 2010, Cloudscaling
#

[:setup, :build, :start].each do |a|

  node[:swift_servers]["account-server"].each do |p,d|
    swift_service "account-server" do
      port p.to_i
      devices d
      action a
    end

    t = resources(:template => "/etc/rsyncd.conf")
    t.variables[:servers]["account" + p.to_s] = d

  end
end

["account-replicator","account-auditor","account-reaper"].each do |s|
  swift_init_script s

  service "swift-#{s}" do
    action [ :start, :enable ]
  end
end
