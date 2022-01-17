#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 5.4 of the benchmark:
# Access, Authentication and Authorization - User Accounts and Environment

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 5.4 (Access, Authentication and Authorization - User Accounts and \
Environment) for the CIS Distribution Independent Linux Benchmark v2.0.0 - \
07-16-2019 benchmark."

cp -a /etc/login.defs /etc/login.defs.pre-hardening

echo "5.4.1.1 Ensure password expiration is 365 days or less"
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 365/g' /etc/login.defs
chage --maxdays 365 ec2-user

echo "5.4.1.2 Ensure minimum days between password changes is 7 or more"
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 7/g' /etc/login.defs
chage --mindays 7 ec2-user

echo "5.4.1.3 Ensure password expiration warning days is 7 or more"
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/g' /etc/login.defs
chage --warndays 7 ec2-user

echo "5.4.1.4 Ensure inactive password lock is 30 days or less [CUSTOM: Set to 90 days instead]"
useradd -D -f 90
chage --inactive 90 ec2-user

echo "5.4.2 Ensure system accounts are secured"
awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $7!="'"$(which nologin)"'" && $7!="/bin/false") {print $1}' /etc/passwd | while read user; do usermod -s $(which nologin) $user; done
awk -F: '($1!="root" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"') {print $1}' /etc/passwd | xargs -I '{}' passwd -S '{}' | awk '($2!="L" && $2!="LK") {print $1}' | while read user; do usermod -L $user; done

echo "5.4.3 Ensure default group for the root account is GID 0"
usermod -g 0 root

echo "5.4.4 Ensure default user umask is 027 or more restrictive"
cp -a /etc/bashrc /etc/bashrc.pre-hardening
cp -a /etc/profile /etc/profile.pre-hardening
sed -ri 's/umask [0-9]{3}/umask 027/g' /etc/bashrc
sed -ri 's/umask [0-9]{3}/umask 027/g' /etc/profile

echo "5.4.5 Ensure default user shell timeout is 900 seconds or less"
echo "TMOUT=300" >> /etc/bashrc
echo "TMOUT=300" >> /etc/profile
