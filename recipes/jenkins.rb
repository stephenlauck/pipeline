#
# Author:: Stephen Lauck <lauck@opscode.com>
# Author:: Mauricio Silva <msilva@exacttarget.com>
#
# Cookbook Name:: pipeline
# Recipe:: default
#
# Copyright 2013, Exact Target
# Copyright 2013, Opscode, Inc.
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
#



# create /var/run/jenkins because of https://issues.jenkins-ci.org/browse/JENKINS-20407 
directory "/var/run/jenkins" do 
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  recursive true
end

include_recipe "jenkins::server"
include_recipe "jenkins::proxy"

# set jenkins node home to server home
node.default['jenkins']['node']['home'] = node['jenkins']['server']['home']

# override fingerprint rsa for convergence? Security ok?
file "#{node['jenkins']['server']['home']}/.ssh/config" do 
 content <<-EOD
   Host github.com
       StrictHostKeyChecking no 
 EOD
end
