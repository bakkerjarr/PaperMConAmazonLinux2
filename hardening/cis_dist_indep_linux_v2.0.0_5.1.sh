#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 5.1 of the benchmark:
# Access, Authentication and Authorization - Configure cron

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 5.1 (Access, Authentication and Authorization - Configure cron) for \
the CIS Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 \
benchmark."

echo "5.1.2 Ensure permissions on /etc/crontab are configured"
chown root:root /etc/crontab
chmod og-rwx /etc/crontab

echo "5.1.3 Ensure permissions on /etc/cron.hourly are configured"
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly

echo "5.1.4 Ensure permissions on /etc/cron.daily are configured"
chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily

echo "5.1.5 Ensure permissions on /etc/cron.weekly are configured"
chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly

echo "5.1.6 Ensure permissions on /etc/cron.monthly are configured"
chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly

echo "5.1.7 Ensure permissions on /etc/cron.d are configured"
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d

echo "5.1.8 Ensure at/cron is restricted to authorized users"
rm /etc/cron.deny
rm /etc/at.deny
echo "root" > /etc/cron.allow
echo "root" > /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow
