#!/bin/bash

	# Installs postfix and configure to listen only on the local interface. Also
	# allows for local mail delivery

	echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
	echo "postfix postfix/mailname string localhost" | debconf-set-selections
	echo "postfix postfix/destinations string localhost.localdomain, localhost" | debconf-set-selections
	aptitude -y install postfix
	/usr/sbin/postconf -e "inet_interfaces = loopback-only"
	#/usr/sbin/postconf -e "local_transport = error:local delivery is disabled"

	touch /tmp/restart-postfix