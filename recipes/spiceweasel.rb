
gem_package 'spiceweasel' do
  gem_binary('/opt/chef/embedded/bin/gem')
end


job_name = 'spiceweasel'

job_config = File.join(node['jenkins']['node']['home'], "#{job_name}-config.xml")

jenkins_job job_name do
  action :nothing
  config job_config
end

template job_config do
  source    'spiceweasel-config.xml.erb'
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  variables({
    :github_url => node['pipeline']['spiceweasel']['repo_url'],
    :git_url => node['pipeline']['spiceweasel']['clone_url'],
    :branch => node['pipeline']['spiceweasel']['branch'],
    :yml_file => node['pipeline']['spiceweasel']['yml_file']
  })
  notifies :update, "jenkins_job[#{job_name}]", :immediately
  notifies :build, "jenkins_job[#{job_name}]", :immediately
end

