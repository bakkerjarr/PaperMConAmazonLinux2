#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 1.7 of the benchmark:
# Initial Setup - Warning Banners

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 1.7 (Initial Setup - Warning Banners) for the CIS Distribution \
Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "1.7.1.1 Ensure message of the day is configured properly"
mv /etc/motd /etc/motd.orig
cat >/etc/motd <<TEXT_OUTPUT
#--------------------------------------------------------------------#
 Hello there and welcome to this host. Provided everything is working
 as intended, this event has been logged and so will your actions
 that follow. No hard feelings!

 Please treat this host with respect and send any queries to the
 system administrator. Have a nice day.
#--------------------------------------------------------------------#
TEXT_OUTPUT

echo "1.7.1.2 Ensure local login warning banner is configured properly"
mv /etc/issue /etc/issue.orig
cat >/etc/issue <<TEXT_OUTPUT
#--------------------------------------------------------------------#
 Hello there and welcome to this host. In case you are not aware, you
 have arrived here via a local terminal connection. Provided
 everything is working as intended, this event has been logged and so
 will your actions that follow. No hard feelings!

 Please treat this host with respect and send any queries to the
 system administrator. Have a nice day.
#--------------------------------------------------------------------#
TEXT_OUTPUT

echo "1.7.1.3 Ensure remote login warning banner is configured properly"
mv /etc/issue.net /etc/issue.net.orig
cat >/etc/issue.net <<TEXT_OUTPUT
#--------------------------------------------------------------------#
 Hello there and welcome to this host. In case you are not aware, you
 have arrived here via a remote connection (e.g. SSH). Provided
 everything is working as intended, this event has been logged and so
 will your actions that follow. No hard feelings!

 Please treat this host with respect and send any queries to the
 system administrator. Have a nice day.
#--------------------------------------------------------------------#
TEXT_OUTPUT

echo "1.7.1.4 Ensure permissions on /etc/motd are configured"
chown root:root /etc/motd
chmod 644 /etc/motd

echo "1.7.1.5 Ensure permissions on /etc/issue are configured"
chown root:root /etc/issue
chmod 644 /etc/issue

echo "1.7.1.6 Ensure permissions on /etc/issue.net are configured"
chown root:root /etc/issue.net
chmod 644 /etc/issue.net
