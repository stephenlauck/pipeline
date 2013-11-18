include_recipe "apt"

# create /var/run/jenkins because of https://issues.jenkins-ci.org/browse/JENKINS-20407 
directory "/var/run/jenkins" do 
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  recursive true
end

include_recipe "jenkins::server"

# set jenkins node home to server home
node.default['jenkins']['node']['home'] = node['jenkins']['server']['home']

# override fingerprint rsa for convergence? Security ok?
file "#{node['jenkins']['server']['home']}/.ssh/config" do 
 content <<-EOD
   Host github.com
       StrictHostKeyChecking no 
 EOD
end
