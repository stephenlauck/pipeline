
gem_package "berkshelf" do
  gem_binary("/opt/chef/embedded/bin/gem")
  version "2.0.10"
end

# create berkshelf
directory "#{node['jenkins']['server']['home']}/.berkshelf" do
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0755
end




