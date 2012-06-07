#!/bin/bash

function create_deploy_user {
	#$1 - USERNAME
        #$2 - PASSWORD
        #$3 - SSHKEY
	add_user $1 $2 "users,sudo"
	add_ssh_key $1 "$3"
}

function user_home {
	cat /etc/passwd | grep "^$1:" | cut --delimiter=":" -f6
}

function add_user {
	#$1 - USERNAME
	#$2 - PASSWORD
	#$3 - GROUPS
	log "Adding user $1..."
	useradd --create-home --shell "/bin/bash" --user-group --groups "$3" "$1"
	echo "$1:$2" | chpasswd
}

function add_ssh_key {
	#$1 - USERNAME
        #$2 - SSHKEY
	log "Trusting informed public ssh key for user $1..."
	USER_HOME=$(user_home "$1")
	sudo -u "$1" mkdir "$USER_HOME/.ssh"
	sudo -u "$1" touch "$USER_HOME/.ssh/authorized_keys"
        
	# if USER_SSH_KEY contains a URL instead of an actual key then
        # pull it from a remote and cat it into the authorized_keys file
        shopt -s nocasematch;
	if [[ $2 =~ https?://|ftp:// ]]; then 
		log "Loading ssh authorized_keys from remote source $2"
		# pull authorized_keys file from a remote url defined as USER_SSH_KEY	
		wget $2 --output-file=/tmp/ss-ssh.pub
		sudo -u "$1" cat /tmp/ss-ssh.pub >> "$USER_HOME/.ssh/authorized_keys"
	else
		log "Setting ssh authorized_keys content"
		sudo -u "$1" echo "$2" >> "$USER_HOME/.ssh/authorized_keys"
		
	fi
	chmod 0600 "$USER_HOME/.ssh/authorized_keys"
}
