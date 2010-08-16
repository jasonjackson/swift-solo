include_recipe "swift::account-server"
include_recipe "swift::ssl-certificates"

template "/etc/swift/auth-server.conf" do
  source "auth-server.conf.erb"
  owner "swift"
  group "swift"
  variables(
    :use_ssl => node[:swift][:auth_server][:use_ssl],
    :hostname => node[:swift][:proxy_server][:hostname]
  )
end
  
template "/etc/init.d/swift-auth-server" do
  source "init-script.erb"
  mode 0755
  variables(:server => "auth-server")
  backup false
end

service "swift-auth-server" do
  action [:start, :enable]
  subscribes :restart, resources(:template => "/etc/swift/auth-server.conf")
end

