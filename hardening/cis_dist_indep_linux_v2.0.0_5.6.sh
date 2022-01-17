#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 5.4 of the benchmark:
# Access, Authentication and Authorization - Ensure access to the su command is
# restricted

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 5.6 (Access, Authentication and Authorization - Ensure access to the \
su command is restricted) for the CIS Distribution Independent Linux \
Benchmark v2.0.0 - 07-16-2019 benchmark."

cp -a /etc/pam.d/su /etc/pam.d-su.pre-hardening
sed -i '/\#auth\s*required\s*pam_wheel.so use_uid/s/^#//g' /etc/pam.d/su
sed -Ei 's/(wheel:x:[0-9]{2}:).*/\1root/g' /etc/group
