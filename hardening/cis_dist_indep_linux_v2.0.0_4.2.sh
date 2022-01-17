#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 4.2 of the benchmark:
# Logging and Auditing - Configure Logging

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 4.2 (Logging and Auditing - Configure Logging) for the CIS \
Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

cp -a /etc/systemd/journald.conf /etc/systemd/journald.conf.pre-hardening

echo "4.2.2.2 Ensure journald is configured to compress large log files"
sed -i 's/^\#*Compress=.*/Compress=yes/g' /etc/systemd/journald.conf

echo "4.2.2.3 Ensure journald is configured to write logfiles to persistent disk"
sed -i 's/^\#*Storage=.*/Storage=persistent/g' /etc/systemd/journald.conf
