#
# Cookbook Name:: pipeline
# Recipe:: knife
#
# Copyright 2014, Stephen Lauck <lauck@getchef.com>
# Copyright 2014, Chef, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

directory "#{node['jenkins']['master']['home']}/.chef" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['user']
  mode 0755
end

cookbook_file "#{node['jenkins']['master']['home']}/.chef/pipeline.pem" do
  source "pipeline.pem"
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  action :create
end

template "#{node['jenkins']['master']['home']}/.chef/knife.rb" do
  source "knife.rb.erb"
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    :chef_server_url => node['pipeline']['chef_server']['url'],
    :client_node_name => node['pipeline']['chef_server']['node_name'],
  )
end





