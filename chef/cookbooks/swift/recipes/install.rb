#
# Cookbook Name:: swift            
# Recipe:: install
#
# Copyright 2010, Cloudscaling
#

execute "install_swift" do
  command "python setup.py develop"
  cwd "/home/swift/swift"
  action :nothing
end

if(node[:swift][:repository][:url] =~ /git/)

  package "git-core"

  git "/home/swift/swift" do
    user "swift"  
    group "swift"
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
    cwd "/home/swift"
    not_if "test -d /home/swift/swift"
    notifies :run, resources(:execute => "install_swift"), :immediately
  end

end

