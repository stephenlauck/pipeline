use_inline_resources

action :create do
  xml = "#{Chef::Config[:file_cache_path]}/#{new_resource.job_name}.xml"

  template xml do
    source 'job-config.xml.erb'
      variables(
        :git_url => new_resource.git_url,
        :branch => new_resource.branch,
        :polling => new_resource.polling,
        :build_command => new_resource.build_command
      )
  end
 
  jenkins_job new_resource.job_name do
    config xml
  end
end