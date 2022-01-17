#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 3.4 of the benchmark:
# Network Configuration - Uncommon Network Protocols

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 3.4 (Network Configuration - Uncommon Network Protocols) for the CIS \
Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "3.4.1 Ensure DCCP is disabled"
echo "install dccp /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_network_protocols.conf

echo "3.4.2 Ensure SCTP is disabled"
echo "install sctp /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_network_protocols.conf

echo "3.4.3 Ensure RDS is disabled"
echo "install rds /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_network_protocols.conf

echo "3.4.4 Ensure TIPC is disabled"
echo "install tipc /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_network_protocols.conf
