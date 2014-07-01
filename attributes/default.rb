default['pipeline']['jenkins']['plugins'] = %w{ scm-api git git-client github-api github }

default['pipeline']['chef_server']['url'] = "http://0.0.0.0:80"
default['pipeline']['chef_server']['node_name'] = "pipeline"

default['pipeline']['chef-repo']['url'] = "https://github.com/stephenlauck/pipeline_chef.git"
default['pipeline']['chef-repo']['branch'] = "*/master"
default['pipeline']['chef-repo']['polling'] = "* * * * *"
