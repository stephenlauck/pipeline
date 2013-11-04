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

# create /var/run/jenkins for 
directory "/var/run/jenkins" do 
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  recursive true
end

include_recipe "jenkins::server"

# set jenkins node home to server home
node.default['jenkins']['node']['home'] = node['jenkins']['server']['home']

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



##############################################################
# create job to pull down list of cookbooks
# and
# iterate over cookbooks and create job per cookbook in list
##############################################################
# git_branch = 'master'
# job_name = "sigar-#{branch}-#{node[:os]}-#{node[:kernel][:machine]}"

# job_config = File.join(node[:jenkins][:node][:home], "#{job_name}-config.xml")

# jenkins_job job_name do
#   action :nothing
#   config job_config
# end

# template job_config do
#   source    'sigar-jenkins-config.xml'
#   variables :job_name => job_name, :branch => git_branch, :node => node[:fqdn]
#   notifies  :update, resources(:jenkins_job => job_name), :immediately
#   notifies  :build, resources(:jenkins_job => job_name), :immediately
# end








