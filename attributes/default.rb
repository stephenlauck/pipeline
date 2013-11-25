default['jenkins']['server']['plugins']                      = %w{scm-api git git-client github-api github}

default['pipeline']['chef_server']['url']                    = "CHEF_SERVER_URL"
default['pipeline']['chef_server']['client_key']             = "USER_PEM"
default['pipeline']['chef_server']['validation_client_name'] = "VALIDATOR_NAME"
default['pipeline']['chef_server']['validation_key']         = "VALIDATION_PEM"

default['pipeline']['berkshelf']['repo_url']                  = "GITHUB_URL_TO_BERKSFILE"
default['pipeline']['berkshelf']['clone_url']                 = "GIT_CLONE_URL_FOR_BERKSFILE"
default['pipeline']['berkshelf']['branch']                    = "*/master"

default['pipeline']['spiceweasel']['repo_url']                = "GITHUB_URL_TO_SPICEWEASEL"
default['pipeline']['spiceweasel']['clone_url']               = "GIT_CLONE_URL_FOR_SPICEWEASEL"
default['pipeline']['spiceweasel']['branch']                  = "*/master"
default['pipeline']['spiceweasel']['yml_file']                = "infrastructure.yml"

default['pipeline']['chef-zero']                             = false


default['pipeline']['knife']['plugins']                      = %w[ knife-ec2 ]

default['pipeline']['knife']['providers']                    = [
  { "EXAMPLE_KEY" => "YOUR_KEY" },
  { "EXAMPLE_KEY_ID" => "YOUR_KEY_ID" },
  { "EXAMPLE_SECRET" => "YOUR_AWS_SECRET" }
]
