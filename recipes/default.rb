#
# Cookbook Name:: pipeline
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"
include_recipe "jenkins::server"

# set jenkins node home to server home
node.default['jenkins']['node']['home'] = node['jenkins']['server']['home']

# install jenkins plugins
%w( github ).each do |plugin|
  jenkins_cli "install-plugin #{plugin}"
  jenkins_cli "safe-restart"
end

# manage jenkins config?

# create job to pull down list of cookbooks
# and
# iterate over cookbooks and create job per cookbook in list

