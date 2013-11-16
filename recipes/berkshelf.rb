
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


####################################################################
# write out chef server keys via attribute set by wrapper cookbook #
####################################################################
# user.pem
file "#{node['jenkins']['server']['home']}/.berkshelf/#{node['jenkins']['server']['user']}.pem" do
  content node['pipeline']['chef_server']['user_pem']
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  action :create
end

# validation.pem
file "#{node['jenkins']['server']['home']}/.berkshelf/validation.pem" do
  content node['pipeline']['chef_server']['validation_pem']
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  action :create
end

# berkshelf config
template "#{node['jenkins']['server']['home']}/.berkshelf/config.json" do
  source "config.json.erb"
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  variables(
    :chef_server_url        => node['pipeline']['chef_server']['url'],
    :validation_client_name => "chef-validator",
    :validation_key_path    => "#{node['jenkins']['server']['home']}/.berkshelf/validation.pem",
    :client_key_path        => "#{node['jenkins']['server']['home']}/.berkshelf/#{node['jenkins']['server']['user']}.pem",
    :chef_node_name         => node['jenkins']['server']['user']
  )
end


