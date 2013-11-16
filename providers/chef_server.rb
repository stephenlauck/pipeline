use_inline_resources if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('11')

action :create do 
  Chef::Log.info "creating chef server -- #{@new_resource.name}"

  config_path = "#{node['jenkins']['server']['home']}/.berkshelf/"
  client_pem = "#{node['jenkins']['server']['user']}.pem"

# user.pem
  file ::File.join(config_path, client_pem) do 
    content new_resource.user_pem 
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['user']
    mode 0644
    action :create
  end

  # validation.pem
  file ::File.join(config_path, "validation.pem") do 
    content new_resource.validation_pem 
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['user']
    mode 0644
    action :create
  end

  # berkshelf config
  template "#{config_path}/config-#{new_resource.name}.json" do
    source "config.json.erb"
    cookbook 'pipeline'
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['user']
    mode 0644
    variables(
      :chef_server_url        => new_resource.url,
      :validation_client_name => "chef-validator",
      :validation_key_path    => ::File.join(config_path, "validation.pem"),
      :client_key_path        => ::File.join(config_path, client_pem),
      :chef_node_name         => node['jenkins']['server']['user']
    )
  end
end
