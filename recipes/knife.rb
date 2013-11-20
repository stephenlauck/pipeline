### 
#
# 1 - write out knife.rb
# 2 - use chef server information to write file
# 3 - abort if new chef-server information
#
#
# create berkshelf
directory "#{node['jenkins']['server']['home']}/.chef" do
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0755
end


####################################################################
# write out chef server keys via attribute set by wrapper cookbook #
####################################################################
# user.pem
file "#{node['jenkins']['server']['home']}/.chef/#{node['jenkins']['server']['user']}.pem" do
  content node['pipeline']['chef_server']['client_key']
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  action :create
end

# validation.pem
file "#{node['jenkins']['server']['home']}/.chef/#{node['pipeline']['chef_server']['validation_client_name']}.pem" do
  content node['pipeline']['chef_server']['validation_key']
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  action :create
end

template "#{node['jenkins']['server']['home']}/.chef/knife.rb" do
  source "knife.rb.erb"
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  variables(
    :chef_server_url        => node['pipeline']['chef_server']['url'],
    :validation_client_name => node['pipeline']['chef_server']['validation_client_name'],
    :validation_key_path    => "#{node['jenkins']['server']['home']}/.chef/#{node['pipeline']['chef_server']['validation_client_name']}.pem",
    :client_key_path        => "#{node['jenkins']['server']['home']}/.chef/#{node['jenkins']['server']['user']}.pem",
    :chef_node_name         => node['jenkins']['server']['user'],
    :providers              => node['pipeline']['knife']['providers']
  )
end




