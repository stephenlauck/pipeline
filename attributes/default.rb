default['jenkins']['server']['plugins'] = %w{scm-api git git-client github-api github}

default['pipeline']['chef_server']['url'] = "CHEF_SERVER_URL"
default['pipeline']['chef_server']['user_pem'] = "USER_PEM"
default['pipeline']['chef_server']['validation_pem'] = "VALIDATION_PEM"

default['pipeline']['github']['repo_url'] = "GITHUB_URL_TO_BERKSFILE"
default['pipeline']['github']['clone_url'] = "GIT_CLONE_URL_FOR_BERKSFILE"
default['pipeline']['github']['branch'] = "*/master"


## check naming of these
default['pipeline']['build']['commands'] = [
  'foodcritic -f correctness .', 
  'berks upload -c /var/lib/jenkins/.berkshelf/config.json',
  'berks apply dev01 -c /var/lib/jenkins/.berkshelf/config.json'
] 

