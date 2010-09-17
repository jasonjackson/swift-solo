template "/etc/swift/func_test.conf" do
  source "func_test.conf.erb"
  mode 0755
end

execute "make test swift user" do
  command "swift-auth-create-account test tester testing"
end
