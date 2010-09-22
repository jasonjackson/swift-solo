#
# Cookbook Name:: swift            
# Recipe:: install
#
# Copyright 2010, Cloudscaling
#

execute "install_swift" do
  command "python setup.py develop"
  cwd "/home/#{node[:swift][:user]}/swift"
  action :nothing
end

if(node[:swift][:repository][:url] =~ /git/)

  package "git-core"

  git "/home/#{node[:swift][:user]}/swift" do
    user node[:swift][:user]
    group node[:swift][:user]
    reference node[:swift][:repository][:tag]
    repository node[:swift][:repository][:url]
    action :sync
    notifies :run, resources(:execute => "install_swift"), :immediately
  end

else

  package "bzr"
  
  tag = node[:swift][:repository][:tag] ? "-r #{node[:swift][:repository][:tag]}" : ""

  execute "install-swift-bazaar" do
    command "bzr co #{tag} #{node[:swift][:repository][:url]} swift"
    user node[:swift][:user]
    cwd "/home/#{node[:swift][:user]}"
    not_if "test -d /home/#{node[:swift][:user]}/swift"
    notifies :run, resources(:execute => "install_swift"), :immediately
  end

end

