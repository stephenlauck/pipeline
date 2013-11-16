##############################################################
# create job to pull down list of cookbooks
# and
# iterate over cookbooks and create job per cookbook in list
##############################################################
job_name = "berkshelf"

job_config = File.join(node['jenkins']['node']['home'], "#{job_name}-config.xml")

jenkins_job job_name do
  action :nothing
  config job_config
end

template job_config do
  source    'berksfile-config.xml.erb'
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 0644
  variables({
    :github_url => node['pipeline']['github']['repo_url'],
    :git_url => node['pipeline']['github']['clone_url'],
    :branch => node['pipeline']['github']['branch']
 })
  notifies  :update, resources(:jenkins_job => job_name)#, :immediately
  notifies  :build, resources(:jenkins_job => job_name)#, :immediately
end

  begin
    # /var/lib/jenkins/jobs/berkshelf/workspace
    berksfile = File.open("#{node['jenkins']['server']['home']}/jobs/#{job_name}/workspace/Berksfile")

    # cookbook 'jenkins', git: 'git@github.com:stephenlauck/jenkins.git', branch: 'plugin_permissions_fix'
    berksfile.each_line do |line|
      if line =~ /cookbook '(.*)',\s+git:\s+'(.*)'/
        cookbook = $1
        cookbook_url = $2

        Chef::Log.info("#{$1} at #{$2}")
        ## create cookbook job for each matching cookbook
        cookbook_job = "cookbook-#{cookbook}"
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
            :branch => '*/master',
            :build_commands => node['pipeline']['build']['commands']
          })
          notifies  :update, resources(:jenkins_job => cookbook_job), :immediately
          notifies  :build, resources(:jenkins_job => cookbook_job), :immediately
        end
      end
    end
  rescue Exception => e
     Chef::Log.info("Error reading Berksfile: #{e.message}")
  end 

