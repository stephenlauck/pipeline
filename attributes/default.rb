default['pipeline']['jenkins']['plugins'] = %w{ scm-api git git-client github-api github }

default['pipeline']['chef_server']['url'] = "http://127.0.0.1:8889"
default['pipeline']['chef_server']['node_name'] = "pipeline"

default['pipeline']['chef-repo']['url'] = "https://github.com/stephenlauck/pipeline_chef.git"
default['pipeline']['chef-repo']['branch'] = "*/master"
default['pipeline']['chef-repo']['polling'] = "* * * * *"

# default['pipeline']['berkshelf']['repo_url'] = "GITHUB_URL_TO_BERKSFILE"
# default['pipeline']['berkshelf']['clone_url'] = "GIT_CLONE_URL_FOR_BERKSFILE"
# default['pipeline']['berkshelf']['branch'] = "*/master"
# default['pipeline']['berkshelf']['polling'] = "* * * * *"


