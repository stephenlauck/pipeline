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
    :branch => node['pipeline']['berkshelf']['branch'],
    :partials => {
      "berksfile_commands.erb" => node['pipeline']['berkshelf']['command_partial_template']
    }
  })
  notifies  :build, resources(:jenkins_job => berkshelf_job_name), :immediately
  notifies  :update, resources(:jenkins_job => berkshelf_job_name), :immediately
end

  begin
    # /var/lib/jenkins/jobs/berkshelf/workspace
    berksfile = File.open("#{node['jenkins']['server']['home']}/jobs/#{berkshelf_job_name}/workspace/Berksfile")

    # cookbook 'jenkins', git: 'git@github.com:stephenlauck/jenkins.git', branch: 'plugin_permissions_fix'
    berksfile.each_line do |line|
      # ^cookbook\s+['|"](.*)['|"],\s+git:\s+['|"](.*)['|"]$
      if line =~ /cookbook (['"])(.*)\1,\s+git:\s+(['"])([^,]*)\3/
        cookbook = $2
        cookbook_url = $4

        Chef::Log.info("#{$2} at #{$4}")
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
            :cookbook => cookbook,
            :partials => {
              "job_commands.erb" => node['pipeline']['berkshelf']['command_partial_template']
            }
          })
          notifies  :update, resources(:jenkins_job => cookbook_job), :immediately
          notifies  :build, resources(:jenkins_job => cookbook_job), :immediately
        end
      end
    end
  rescue Exception => e
     Chef::Log.info("Error reading Berksfile: #{e.message}")
  end 