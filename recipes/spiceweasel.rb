
gem_package 'spiceweasel' do
  gem_binary('/opt/chef/embedded/bin/gem')
end


spiceweasel_job_name = 'spiceweasel'

spiceweasel_job_config = File.join(node['jenkins']['node']['home'], "#{spiceweasel_job_name}-config.xml")

jenkins_job spiceweasel_job_name do
  action :nothing
  config spiceweasel_job_config
end

template spiceweasel_job_config do
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
  notifies  :update, resources(:jenkins_job => spiceweasel_job_name), :immediately
  notifies  :build, resources(:jenkins_job => spiceweasel_job_name), :immediately
end

