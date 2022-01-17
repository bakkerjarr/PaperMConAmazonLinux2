#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 3.3 of the benchmark:
# Network Configuration - TCP Wrappers

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 3.3 (Network Configuration - TCP Wrappers) for the CIS Distribution \
Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "3.3.4 Ensure permissions on /etc/hosts.allow are configured"
chown root:root /etc/hosts.allow
chmod 644 /etc/hosts.allow

echo "3.3.5 Ensure permissions on /etc/hosts.deny are configured"
chown root:root /etc/hosts.deny
chmod 644 /etc/hosts.deny
