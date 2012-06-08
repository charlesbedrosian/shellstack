#!/bin/bash

######################
# Ruby/RubyGem/Rails #
######################
function install_rvm
{
	#borrowed from http://www.linode.com/stackscripts/view/?StackScriptID=2438
	log "Installing RVM and Ruby dependencies"
	apt-get -y install curl git-core bzip2 build-essential zlib1g-dev libssl-dev

	log "Installing RVM system-wide"
	curl -L get.rvm.io | sudo bash -s stable

	cat >> /etc/profile <<'EOF'
# Load RVM if it is installed,
#  first try to load  user install
#  then try to load root install, if user install is not there.
if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
  . "$HOME/.rvm/scripts/rvm"
elif [ -s "/usr/local/rvm/scripts/rvm" ] ; then
  . "/usr/local/rvm/scripts/rvm"
fi
EOF

	source /etc/profile
}

function install_ruby
{
	#borrowed from http://www.linode.com/stackscripts/view/?StackScriptID=2438
	log "Installing Ruby 1.9.3-$RUBY_RELEASE"

	rvm install 1.9.3-$RUBY_RELEASE
	rvm use 1.9.3-$RUBY_RELEASE --default

	log "setup gems package and other dependencies"
	apt-get -y install libgemplugin-ruby build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev

	log "ruby version information"
	ruby -v
	gem -v
	rvm -v

	log "Updating Ruby gems"
	set_production_gemrc
	gem update --system
}

function create_gemrc {
  log "Creating .gemrc file"
  cat > ~/.gemrc << EOF
verbose: true
bulk_treshold: 1000
install: --no-ri --no-rdoc --env-shebang
benchmark: false
backtrace: false
update: --no-ri --no-rdoc --env-shebang
update_sources: true
EOF
  cp ~/.gemrc $USER_HOME
  chown $USER_NAME:$USER_NAME $USER_HOME/.gemrc
}

function update_rubygems {
  log "Updating rubygems"
  gem update --system
}

function set_rails_production_environment {
  log "Setting rails environment to $R_ENV"
  cat >> /etc/environment << EOF
RAILS_ENV=$R_ENV
RACK_ENV=$R_ENV
EOF
}

function install_bundler {
  log "Installing bundler"
  gem install bundler
}

function install_rails_gem {
	log "Installing rails gem"
	gem install rails
}
