include_recipe "apt"

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


