#
# Cookbook Name:: swift            
# Providers:: service
#
# Copyright 2010, Cloudscaling
#

action :setup do
  name = new_resource.name
  short_name = new_resource.name.sub(/-server/,'')
  devices = new_resource.devices
  port = new_resource.port

  directory "/etc/swift/#{name}" do
    owner node[:swift][:user]
    group node[:swift][:user]
    recursive true
    mode 0755
  end  

  template "/etc/swift/#{name}/#{port}.conf" do
    cookbook "swift"
    source "#{name}.conf.erb"
    owner node[:swift][:user]
    group node[:swift][:user]
    mode 0644
    variables(
      :type => short_name,
      :devices => devices,
      :port => port,
      :user => node[:swift][:user]
    )
    notifies :restart, resources(:swift_service => name)
    backup false
  end

  directory "/var/run/swift/#{name}" do
    owner node[:swift][:user]
    group node[:swift][:user]
  end

  if(devices)
    directory devices do
      owner node[:swift][:user]
      group node[:swift][:user]
    end
  end

  swift_init_script name
end

action :rebalance do
  short_name = new_resource.name.sub(/-server/,'')

  execute "rebalance-#{short_name}" do
    cwd "/etc/swift"
    command "/usr/local/bin/swift-ring-builder #{short_name}.builder rebalance"
    user node[:swift][:user]
  end
end

action :start do
  short_name = new_resource.name.sub(/-server/,'')

  service "swift-#{new_resource.name}" do
    action :start
  end
end

action :stop do
  short_name = new_resource.name.sub(/-server/,'')

  service "swift-#{new_resource.name}" do
    action :stop
  end

end

action :build do
  short_name = new_resource.name.sub(/-server/,'')

  execute "build-#{new_resource.name}-ring" do
    user node[:swift][:user]
    cwd "/etc/swift"
    command "/usr/local/bin/swift-ring-builder #{short_name}.builder create #{new_resource.part_power} #{new_resource.replicas} #{new_resource.min_part_hours}"
    creates "/etc/swift/#{short_name}.builder"
  end

  service "swift-#{new_resource.name}" do
    action :enable
  end
end

action :restart do
  execute "restart-#{new_resource.name}" do
    command "/usr/local/bin/swift-init #{new_resource.name} restart"
  end  
end
