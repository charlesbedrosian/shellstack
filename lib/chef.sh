#!/bin/bash

#borrowed from http://www.linode.com/stackscripts/view/?StackScriptID=2438
function install_chef {
	log "Installing Chef"
	gem install chef
	log "Configuring Chef solo"
	mkdir /etc/chef
cat >> /etc/chef/solo.rb <<EOF
file_cache_path "/tmp/chef"
cookbook_path "/tmp/chef/cookbooks"
role_path "/tmp/chef/roles"
EOF
}