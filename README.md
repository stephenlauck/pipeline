# pipeline cookbook

# Requirements

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

# Recipes

# Author

Author:: YOUR_NAME (<YOUR_EMAIL>)
