require 'berkshelf'

pipeline_job "chef-repo" do
  git_url node['pipeline']['chef-repo']['url']
  build_command '_chef_repo_command.sh.erb'
end

begin
  berksfile = Berkshelf::Berksfile.from_file("#{node['jenkins']['master']['home']}/jobs/chef-repo/workspace/Berksfile")
  
  Chef::Log.info("running install on Berksfile...")
  
  begin
    berksfile.update
  rescue
    berksfile.install
  end
  
  berksfile.list.reject{|c| c.location == nil}.each do |cookbook|
    Chef::Log.info(cookbook.location.to_s)
    pipeline_job cookbook.name do
      git_url cookbook.location.uri
      build_command '_cookbook_command.sh.erb'
    end
  end
rescue Exception => e
  Chef::Log.error("Error reading Berksfile: #{e.message}")
end
