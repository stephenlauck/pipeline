
#
# Cookbook Name:: wrapper_pipeline
# Recipe:: chef-zero
#
# 
# All rights reserved - Do Not Redistribute
#
node.set['pipeline']['chef_server']['url'] = 'http://localhost:8889'

gem_package 'chef-zero' do
  gem_binary('/opt/chef/embedded/bin/gem')
  version '1.7.2'
end

template '/etc/init/chef-zero.conf' do
  source 'chef-zero.conf.erb'
  variables({chef_embed_path: '/opt/chef/bin', chef_server_port: '8889'})
  owner 'root'
  group 'root'
end

link '/etc/init.d/chef-zero' do
  to '/lib/init/upstart-job'
  owner 'root'
  group 'root'
end

service 'chef-zero' do
  provider Chef::Provider::Service::Upstart
  Chef::Log.info "Starting Chef-Zero service"
  action [:enable, :start]
end
  
