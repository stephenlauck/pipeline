#
# Cookbook Name:: pipeline
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"
include_recipe "git"
include_recipe "jenkins::server"

# set jenkins node home to server home
node.default['jenkins']['node']['home'] = node['jenkins']['server']['home']

# jenkins home /var/lib/jenkins



# install berkshelf gem
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
    :chef_node_name         => node['jenkins']['user']
  )
end

# write out berks config
# write out chef keys




# create berks config.json
     # "chef_server_url": "<%= chef_server_url %>",
     #    "validation_client_name": "<%= validation_client_name %>",
     #    "validation_key_path": "<%= validation_key_path %>",
     #    "client_key": "<%= client_key_path %>",
     #    "node_name": "<%= chef_node_name %>"

# create job to pull down list of cookbooks
# and
# iterate over cookbooks and create job per cookbook in list

