#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 3.1 of the benchmark:
# Network Configuration - Network Parameters (Host Only)

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 3.1 (Network Configuration - Network Parameters (Host Only)) for the \
CIS Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "3.1.1 Ensure IP forwarding is disabled"
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_only.conf
echo "net.ipv6.conf.all.forwarding = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_only.conf

echo "3.1.2 Ensure packet redirect sending is disabled"
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_only.conf
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_only.conf
