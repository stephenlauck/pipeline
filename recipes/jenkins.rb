#
# Cookbook Name:: pipeline
# Recipe:: jenkins
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
#

include_recipe "jenkins::java"
include_recipe "jenkins::master"

jenkins_command 'safe-restart' do
  action :nothing
end

node['pipeline']['jenkins']['plugins'].each do |p|
  jenkins_plugin p do
    action :install
    notifies :execute, "jenkins_command[safe-restart]", :delayed
  end
end
