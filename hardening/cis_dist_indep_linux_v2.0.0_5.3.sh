#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 5.3 of the benchmark:
# Access, Authentication and Authorization - Configure PAM

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 5.3 (Access, Authentication and Authorization - Configure PAM) for \
the CIS Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 \
benchmark."

echo "5.3.1 Ensure password creation requirements are configured"
cp -a /etc/security/pwquality.conf /etc/security/pwquality.conf.pre-hardening
cat >>/etc/security/pwquality.conf <<TEXT_OUTPUT
minlen = 14
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
TEXT_OUTPUT

echo "5.3.3 Ensure password reuse is limited"
cp -a /etc/pam.d/system-auth /etc/pam.d/system-auth.pre-hardening
sed -i 's/password\s*sufficient\s*pam_unix.so try_first_pass use_authtok nullok sha512 shadow/& remember=5/g' /etc/pam.d/system-auth
