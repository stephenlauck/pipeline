use_inline_resources if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('11')

action :create do 

    setup_berks

    ## todo: better way?
    setup_cookbooks if ::File.exists?("#{node['jenkins']['server']['home']}/jobs/berkshelf/workspace/Berksfile")

end

def setup_cookbooks

    Chef::Log.info "creating berks group rule for  -- #{new_resource.name}"
    Chef::Log.debug "new_resource is:\n#{new_resource.inspect}"

    berksfile = BerkDSL.new("#{node['jenkins']['server']['home']}/jobs/berkshelf/workspace/Berksfile")

    berksfile_group = berksfile.groups[new_resource.name.to_sym]

    ## todo: better way??
    abort "the group does not exist" if berksfile_group.nil?
    abort "the group does not exist" if berksfile_group.cookbooks.empty?

    berksfile_group.cookbooks.each do | cookbook |
      cookbook_job        = cookbook.label
      cookbook_url        = cookbook.options[:git]
      cookbook_job_config = ::File.join(node['jenkins']['node']['home'], "#{cookbook_job}-config.xml")

      jenkins_job cookbook_job do
        action :nothing
        config cookbook_job_config
      end

      template cookbook_job_config do
        cookbook 'pipeline'
        source    'cookbook-config.xml.erb'
        owner node['jenkins']['server']['user']
        group node['jenkins']['server']['user']
        mode 0644
        variables({
          :partial =>  new_resource.commands_template,
          :git_url => cookbook_url,
          :branch => cookbook.options[:branch] || '*/master'
        })
        notifies  :update, resources(:jenkins_job => cookbook_job), :immediately
        notifies  :build, resources(:jenkins_job => cookbook_job), :immediately
      end
    end
end

def setup_berks

  berkshelf_job_name = "berkshelf"

  Chef::Log.info "[pipeline] setting up berkshelf job"

  berkshelf_job_config = ::File.join(node['jenkins']['node']['home'], "#{berkshelf_job_name}-config.xml")

  jenkins_job berkshelf_job_name do
    action :nothing
    config berkshelf_job_config
  end

  template berkshelf_job_config do
    source    'berksfile-config.xml.erb'
    cookbook  'pipeline'
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
end
