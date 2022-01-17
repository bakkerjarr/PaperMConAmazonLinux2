#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 1.5 of the benchmark:
# Initial Setup - Additional Process Hardening

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 1.5 (Initial Setup - Additional Process Hardening) for the CIS \
Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "1.5.1 Ensure core dumps are restricted"
echo "fs.suid_dumpable = 0" >> /etc/sysctl.d/cis_hardening_process_hardening.conf

echo "1.5.3 Ensure address space layout randomization (ASLR) is enabled"
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.d/cis_hardening_process_hardening.conf
