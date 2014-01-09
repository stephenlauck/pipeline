pipeline cookbook
=================
Creates a continuous delivery pipeline using jenkins for Chef artifacts (currently using Berkshelf for cookbooks)

Requirements
------------



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

Resource/Provider
-----------------

**wip**

`pipeline_berkfile` provider will allow you to set jenkins build commands via a template from wrapper.

      pipeline_berksfile "sml"  do 
        commands_template 'build_commands.erb'
      end

This will apply the `build_command` template partial to the jenkins job config.xml file allowing you to apply testing or upload commands based on berksfile group.
This is possible by the addition of the BerkDsl class that wraps the berksfile up and exposes a cookbooks and groups collection -- check out `libraries/berks_dsl` for more details.


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

Recipes
-------

Usage
-----

Author
------

Author:: Stephen Lauck (<lauck@opscode.com>)

Author:: Mauricio Silva (<mauricio.silva@gmail.com>)

