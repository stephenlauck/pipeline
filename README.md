# pipeline cookbook
check changelog for details

# Requirements

#### vagrant-cachier
`vagrant plugin install vagrant-cachier`

# Usage

Attributes
----------
### default
The following attributes are used by by the pipeline default recipe to set up berks/chef/github access.

* `node['jenkins']['server']['plugins'] = %w{github}` - list of plugins needed by jenkins, minimally needs github
* `node['pipeline']['chef_server']['url'] = "CHEF_SERVER_URL"` - url of chef server
* `node['pipeline']['chef_server']['user_pem'] = "USER_PEM"` - key of user with access to chef server
* `node['pipeline']['chef_server']['validation_pem'] = "VALIDATION_PEM"` - validation key for chef server
* `node['jenkins']['server']['pubkey'] should be set to a valid rsa with access to your github org` - override key created by jenkins with actual key with access to github org or repos containing cookbooks.
* node['pipeline']['build']['commands'] is and array of build step commands used by jenkins job eg `['foodcritic -f correctness .', 'berks upload']`

# Resource/Provider

**wip**

`pipeline_chef_server` lwrp will allow the chef_server configuration settings ala a berks config file.

currently only `:create` is supported as follows:

      pipeline_chef_server 'prodserver' do 
        user_pem node['pipeline']['chef_server']['user_pem']
        validation_pem node['pipeline']['chef_server']['validation_pem']
        url node['pipeline']['chef_server']['url']
        action :create
      end
      
params of note:

* `user_pem` : contents so of the client.pem from knife.rb
* `validation_pem`: contents so of the validation.pem from knife.rb
* `url`: chef server fqdn

# Recipes



# Author

Author:: YOUR_NAME (<YOUR_EMAIL>)
