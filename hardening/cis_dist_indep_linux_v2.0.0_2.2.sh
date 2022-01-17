#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 2.2 of the benchmark:
# Services - Special Purpose Services

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 2.2 (Services - Special Purpose Services) for the CIS Distribution \
Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "2.2.7 Ensure NFS and RPC are not enabled"
systemctl disable nfs.service
systemctl disable rpcbind.service
systemctl disable rpcbind.socket
systemctl stop nfs.service
systemctl stop rpcbind.service
systemctl stop rpcbind.socket

echo "2.2.16 Ensure rsync service is not enabled"
systemctl disable rsyncd.service
systemctl disable rsyncd.socket
systemctl stop rsyncd.service
systemctl stop rsyncd.socket
