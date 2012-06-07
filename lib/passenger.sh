#!/bin/bash

function install_passenger_with_nginx_via_rvm
{
	log "Instaling Phusion Passenger and Nginx"
	gem install passenger
	passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx

	log "Setting up Nginx to start on boot and rotate logs"
	set_nginx_boot_up
		
 cat <<EOF > /opt/nginx/conf.d/passenger.conf
passenger_root /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.11;
passenger_ruby /usr/local/bin/ruby;
EOF
  cat <<EOF > /opt/nginx/nginx.conf
user www-data;
worker_processes 6;
pid /var/run/nginx.pid;

events {
        worker_connections 1024;
}

http {
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;

  include /opt/nginx/mime.types;
  default_type application/octet-stream;

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  include /opt/nginx/conf.d/*.conf;
  include /opt/nginx/sites-enabled/*;
}
EOF
  cat <<EOF > /opt/nginx/sites-available/default
server {
  listen 80;
  server_name $DOMAIN_NAME;
  root /home/$USER_NAME/production/current/public;
  passenger_enabled on;
  access_log /var/log/nginx/app.access.log;
  error_log /var/log/nginx/app.error.log;
  gzip  on;
  gzip_http_version 1.1;
  gzip_comp_level 6;
  gzip_proxied any;
  gzip_min_length  1024;
  gzip_buffers 16 8k;
  gzip_types text/plain text/html text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
  gzip_vary on;
  gzip_disable “MSIE [1-6].(?!.*SV1)”;
}
EOF
  ln -s /opt/nginx/sites-available/default /opt/nginx/sites-enabled/default
  /etc/init.d/nginx start	
}