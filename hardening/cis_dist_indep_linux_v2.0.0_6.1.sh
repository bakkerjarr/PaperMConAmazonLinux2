#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 6.1 of the benchmark:
# System Maintenance - System File Permissions

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 6.1 (System Maintenance - System File Permissions) for the CIS \
Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "6.1.2 Ensure permissions on /etc/passwd are configured"
chown root:root /etc/passwd
chmod 644 /etc/passwd

echo "6.1.3 Ensure permissions on /etc/shadow are configured"
chown root:root /etc/shadow
chmod o-rwx,g-wx /etc/shadow

echo "6.1.4 Ensure permissions on /etc/group are configured"
chown root:root /etc/group
chmod 644 /etc/group

echo "6.1.5 Ensure permissions on /etc/gshadow are configured"
chown root:root /etc/gshadow
chmod go-rwx /etc/gshadow

echo "6.1.6 Ensure permissions on /etc/passwd- are configured"
chown root:root /etc/passwd-
chmod u-x,go-rwx /etc/passwd-

echo "6.1.7 Ensure permissions on /etc/shadow- are configured"
chown root:root /etc/shadow-
chmod go-rwx /etc/shadow-

echo "6.1.8 Ensure permissions on /etc/group- are configured"
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-

echo "6.1.9 Ensure permissions on /etc/gshadow- are configured"
chown root:root /etc/gshadow-
chmod go-rwx /etc/gshadow-
