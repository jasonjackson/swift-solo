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

  execute "install-swift-bazaar" do
    command "bzr co -r tag:#{node[:swift][:repository][:tag]} #{node[:swift][:repository][:url]}"
    cwd "/home/swift"
    not_if "test -d /home/swift/swift"
    notifies :run, resources(:execute => "install_swift"), :immediately
  end

end

