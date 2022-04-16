#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 4.1 of the benchmark:
# Logging and Auditing - Configure System Accounting (auditd)

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 4.1 (Logging and Auditing - Configure System Accounting (auditd)) for \
the CIS Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 \
benchmark."

echo "4.1.4 Ensure auditing for processes that start prior to auditd is enabled"
cp -a /etc/default/grub /etc/default/grub.pre-audit_enabled
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty0 console=ttyS0,115200n8 selinux=1 security=selinux enforcing=1 /GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty0 console=ttyS0,115200n8 selinux=1 security=selinux enforcing=1 audit=1 /g' /etc/default/grub
grub2-mkconfig -o /etc/grub2.cfg

echo "4.1.5 Ensure events that modify date and time information are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
TEXT_OUTPUT

echo "4.1.6 Ensure events that modify user/group information are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
TEXT_OUTPUT

echo "4.1.7 Ensure events that modify the system's network environment are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
TEXT_OUTPUT

echo "4.1.8 Ensure events that modify the system's Mandatory Access Controls are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /etc/selinux/ -p wa -k MAC-policy
-w /usr/share/selinux/ -p wa -k MAC-policy
TEXT_OUTPUT

echo "4.1.9 Ensure login and logout events are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/log/tallylog -p wa -k logins
TEXT_OUTPUT

echo "4.1.10 Ensure session initiation information is collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k logins
-w /var/log/btmp -p wa -k logins
TEXT_OUTPUT

echo "4.1.11 Ensure discretionary access control permission modification events are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
TEXT_OUTPUT

echo "4.1.12 Ensure unsuccessful unauthorized file access attempts are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
TEXT_OUTPUT

echo "4.1.13 Ensure use of privileged commands is collected"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print "-a always,exit -F path=" $1 " -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" }' >> /etc/audit/rules.d/cis_hardening_system_accounting.rules

echo "4.1.14 Ensure successful file system mounts are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
TEXT_OUTPUT

echo "4.1.15 Ensure file deletion events by users are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
TEXT_OUTPUT

echo "4.1.16 Ensure changes to system administration scope (sudoers) is collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope
TEXT_OUTPUT

echo "4.1.17 Ensure system administrator actions (sudolog) are collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /var/log/sudo.log -p wa -k actions
TEXT_OUTPUT

echo "4.1.18 Ensure kernel module loading and unloading is collected"
cat >>/etc/audit/rules.d/cis_hardening_system_accounting.rules <<TEXT_OUTPUT
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module -S delete_module -k modules
TEXT_OUTPUT

echo "4.1.19 Ensure the audit configuration is immutable"
echo "-e 2" > /etc/audit/rules.d/99-finalize.rules
