
# default['jenkins']['server']['plugins'] = %w{ssh-credentials credentials scm-api git-client git github-api github}
default['jenkins']['server']['plugins'] = %w{scm-api git git-client github-api github}

default['pipeline']['chef_server']['url'] = "CHEF_SERVER_URL"
default['pipeline']['chef_server']['user_pem'] = "USER_PEM"
default['pipeline']['chef_server']['validation_pem'] = "VALIDATION_PEM"
