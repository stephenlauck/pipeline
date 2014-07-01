require 'berkshelf'

pipeline_job "chef-repo" do
  git_url node['pipeline']['chef-repo']['url']
  build_command '_chef_repo_command.sh.erb'
  https_proxy node['pipeline']['proxy']['https']
end

begin
  berksfile = Berkshelf::Berksfile.from_file("#{node['jenkins']['master']['home']}/jobs/chef-repo/workspace/Berksfile")
  
  berksfile.install
  
  berksfile.list.reject{|c| c.location == nil}.each do |cookbook|
    pipeline_job cookbook.name do
      git_url cookbook.location.uri
      build_command '_cookbook_command.sh.erb'
      https_proxy node['pipeline']['proxy']['https']
    end
  end
rescue Exception => e
  Chef::Log.error("Error reading Berksfile: #{e.message}")
end
