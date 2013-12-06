env = node.chef_environment

if Chef::Config[:solo]
  applications = []
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  applications = search(:applications, "*:*") 
end

applications.each do |application|

  application_job_name = application.id

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
      :repo_url => application['repo_url'],
      :clone_url => application['clone_url'],
      :test_command => application['test_command'],
      :knife_search_string=> application['knife_search_string'],
      :branch => application['branch']
      # :environment=> env
    })
    notifies  :update, resources(:jenkins_job => application_job_name), :immediately
    notifies  :build, resources(:jenkins_job => application_job_name), :immediately
  end

end



