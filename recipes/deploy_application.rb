env = node.chef_environment

applications = search(:applications, "*:*") 

applications.each do |app|

  application_job_name = app['id']

  Chef::Log.info "creating application_deploy job for #{application_job_name}"

  application_job_config = File.join(node['jenkins']['node']['home'], "app-#{application_job_name}-config.xml")

  jenkins_job application_job_name do
    action :nothing
    config application_job_config
  end

  template application_job_config do
    source    'deploy-application-config.xml.erb'
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['user']
    mode 0644
    variables({
      # :name => application_job_name,
      :github_url => app['repo_url'],
      :git_url => app['clone_url'],
      :test_command => app['test_command'],
      # :knife_search_string=> app['knife_search_string'],
      :branch => app['branch']
      # :environment=> env
    })
    notifies  :update, resources(:jenkins_job => application_job_name), :immediately
    notifies  :build, resources(:jenkins_job => application_job_name), :immediately
  end

end



