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

# manage jenkins config
template "/var/lib/jenkins/config.xml" do
  source "config.xml.erb"
  mode 0644
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
	variables({

    })
end

# install jenkins plugins

# %w(git URLSCM build-publisher).each do |plugin|
#   jenkins_cli "install-plugin #{plugin}"
#   jenkins_cli "safe-restart"
# end

# or

# jenkins_plugin 'ant' do
#   action :install
#   version '1.2'
# end

# create job to pull down list of cookbooks
# and
# iterate over cookbooks and create job per cookbook in list

