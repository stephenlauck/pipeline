
#
#  
#  git url
#
#  test command
#
#  search string
#
#  environment
#
#

env = node.chef_environment

applications = data_bag('applications')

applications.each do |app|

  deploy_application = data_bag_item('applications', app)

  job_name = deploy_application[:id]

  job_config = File.join(node['jenkins']['node']['home'], "app-#{job_name}-config.xml")

  jenkins_job job_name do
    action :nothing
    config job_config
  end

  template job_config do
    source    'application_job-config.xml.erb'
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['user']
    mode 0644
    variables({
      :name => deploy_application['id'],
      :repo_url => deploy_application['repo_url'],
      :clone_url => deploy_application['clone_url'],
      :test_command=> deploy_application['test_command'],
      :knife_search_string=> deploy_application['knife_search_string'],
      :branch => deploy_appliation['branch'],
      :environment=> env
    })
    notifies  :update, resources(:jenkins_job => job_name), :immediately
    notifies  :build, resources(:jenkins_job => job_name), :immediately
  end

end
