#servers will be set by other recipes
#this template must exist before the server recipes are called
template "/etc/rsyncd.conf" do
  source "rsyncd.conf.erb"
  variables(
    :servers => {}
  )
end

cookbook_file "/etc/default/rsync" do
  source "default-rsync"
end

service "rsync" do
  action :start
  supports :restart => true
  subscribes :restart, resources(:template => "/etc/rsyncd.conf")
end


