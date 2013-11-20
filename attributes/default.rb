default['jenkins']['server']['plugins']                      = %w{scm-api git git-client github-api github}

default['pipeline']['chef_server']['url']                    = "CHEF_SERVER_URL"
default['pipeline']['chef_server']['client_key']             = "USER_PEM"
default['pipeline']['chef_server']['validation_client_name'] = "VALIDATOR_NAME"
default['pipeline']['chef_server']['validation_key']         = "VALIDATION_PEM"

default['pipeline']['github']['repo_url']                    = "GITHUB_URL_TO_BERKSFILE"
default['pipeline']['github']['clone_url']                   = "GIT_CLONE_URL_FOR_BERKSFILE"
default['pipeline']['github']['branch']                      = "*/master"


default['pipeline']['chef-zero']                             = false

default['pipeline']['knife']['providers'] = {
  "ec2" => {
      "aws_access_key_id" => "YOUR_AWS_KEY",
      "aws_secret_access_key" => "YOUR_AWS_SECRET"
    }
}