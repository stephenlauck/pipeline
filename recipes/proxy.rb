template "#{node['jenkins']['master']['home']}/proxy.xml" do
  source "proxy.xml.erb"
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    :proxy => node['pipeline']['proxy']['https'],
    :port => node['pipeline']['proxy']['port']
  )
end