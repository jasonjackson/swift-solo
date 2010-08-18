[:setup, :build, :start].each do |a|

  node[:swift_servers]["account-server"].each do |p,d|
    swift_service "account-server" do
      port p.to_i
      devices d
      action a
    end

    t = resources(:template => "/etc/rsyncd.conf")
    t.variables[:servers]["account-server" + p.to_s] = d

  end
end

["account-replicator","account-auditor","account-reaper"].each do |s|
  template "/etc/init.d/swift-#{s}" do
    source "init-script.erb"
    mode 0755
    variables(:server => s)
  end

  service "swift-#{s}" do
    action [ :start, :enable ]
  end
end
