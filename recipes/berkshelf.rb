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
  content node['pipeline']['chef_server']['client_key']
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  action :create
end

# validation.pem
file "#{node['jenkins']['server']['home']}/.berkshelf/#{node['pipeline']['chef_server']['validation_client_name']}.pem" do
  content node['pipeline']['chef_server']['validation_key']
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
    :validation_client_name => node['pipeline']['chef_server']['validation_client_name'],
    :validation_key_path    => "#{node['jenkins']['server']['home']}/.berkshelf/#{node['pipeline']['chef_server']['validation_client_name']}.pem",
    :client_key_path        => "#{node['jenkins']['server']['home']}/.berkshelf/#{node['jenkins']['server']['user']}.pem",
    :chef_node_name         => node['jenkins']['server']['user']
  )
end

##############################################################
# create job to pull down list of cookbooks
# and
# iterate over cookbooks and create job per cookbook in list
##############################################################

berkshelf_job_name = "berkshelf"

berkshelf_job_config = File.join(node['jenkins']['node']['home'], "#{berkshelf_job_name}-config.xml")

jenkins_job berkshelf_job_name do
  action :nothing
  config berkshelf_job_config
end

template berkshelf_job_config do
  source    'berksfile-config.xml.erb'
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  variables({
    :github_url => node['pipeline']['berkshelf']['repo_url'],
    :git_url => node['pipeline']['berkshelf']['clone_url'],
    :branch => node['pipeline']['berkshelf']['branch']
  })
  notifies  :build, resources(:jenkins_job => berkshelf_job_name), :immediately
  notifies  :update, resources(:jenkins_job => berkshelf_job_name), :immediately
end

  begin
    Chef::Log.info "Creating Berkfile Jenkins Job."

    berksfile = BerkDSL.new("#{node['jenkins']['server']['home']}/jobs/#{berkshelf_job_name}/workspace/Berksfile")

    Chef::Log.info("groups\s #{berksfile.inspect}")

    groups_to_test = node['pipeline']['groups_to_test'] 

    berksfile.groups[groups_to_test].cookbooks.each do | cookbook |

      cookbook_job        = cookbook.label
      cookbook_url        = cookbook.options[:git]
      cookbook_job_config = File.join(node['jenkins']['node']['home'], "#{cookbook_job}-config.xml")

      jenkins_job cookbook_job do
        action :nothing
        config cookbook_job_config
      end

      template cookbook_job_config do
        source    'cookbook-config.xml.erb'
        owner node['jenkins']['server']['user']
        group node['jenkins']['server']['user']
        mode 0644
        variables({
          :git_url => cookbook_url,
          :branch => cookbook.options[:branch] || '*/master'
        })
        notifies  :update, resources(:jenkins_job => cookbook_job), :immediately
        notifies  :build, resources(:jenkins_job => cookbook_job), :immediately
      end
    end
  rescue Exception => e
     Chef::Log.info("Error reading Berksfile: #{e.message}")
  end 




