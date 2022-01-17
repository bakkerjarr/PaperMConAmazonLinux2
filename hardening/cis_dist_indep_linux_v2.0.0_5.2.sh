#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 5.2 of the benchmark:
# Access, Authentication and Authorization - SSH Server Configuration

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 5.2 (Access, Authentication and Authorization - SSH Server \
Configuration) for the CIS Distribution Independent Linux Benchmark v2.0.0 \
- 07-16-2019 benchmark."

cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config.pre-hardening

echo "5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured"
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config

echo "5.2.2 Ensure permissions on SSH private host key files are configured"
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;

echo "5.2.3 Ensure permissions on SSH public host key files are configured"
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 0644 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

echo "5.2.4 Ensure SSH Protocol is set to 2"
echo "Protocol 2" >> /etc/ssh/sshd_config

echo "5.2.5 Ensure SSH LogLevel is appropriate"
sed -i 's/^\#*LogLevel .*/LogLevel VERBOSE/g' /etc/ssh/sshd_config

echo "5.2.6 Ensure SSH X11 forwarding is disabled"
sed -i 's/^\#*X11Forwarding .*/X11Forwarding no/g' /etc/ssh/sshd_config

echo "5.2.7 Ensure SSH MaxAuthTries is set to 4 or less"
sed -i 's/^\#*MaxAuthTries .*/MaxAuthTries 4/g' /etc/ssh/sshd_config

echo "5.2.8 Ensure SSH IgnoreRhosts is enabled"
sed -i 's/^\#*IgnoreRhosts .*/IgnoreRhosts yes/g' /etc/ssh/sshd_config

echo "5.2.9 Ensure SSH HostbasedAuthentication is disabled"
sed -i 's/^\#*HostbasedAuthentication .*/HostbasedAuthentication no/g' /etc/ssh/sshd_config

echo "5.2.10 Ensure SSH root login is disabled"
sed -i 's/^\#*PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config

echo "5.2.11 Ensure SSH PermitEmptyPasswords is disabled"
sed -i 's/^\#*PermitEmptyPasswords .*/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

echo "5.2.12 Ensure SSH PermitUserEnvironment is disabled"
sed -i 's/^\#*PermitUserEnvironment .*/PermitUserEnvironment no/g' /etc/ssh/sshd_config

echo "5.2.13 Ensure only strong Ciphers are used"
echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >> /etc/ssh/sshd_config

echo "5.2.14 Ensure only strong MAC algorithms are used"
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> /etc/ssh/sshd_config

echo "5.2.15 Ensure only strong Key Exchange algorithms are used"
echo "KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256" >> /etc/ssh/sshd_config

echo "5.2.16 Ensure SSH Idle Timeout Interval is configured"
sed -i 's/^\#*ClientAliveInterval .*/ClientAliveInterval 300/g' /etc/ssh/sshd_config
sed -i 's/^\#*ClientAliveCountMax .*/ClientAliveCountMax 0/g' /etc/ssh/sshd_config

echo "5.2.17 Ensure SSH LoginGraceTime is set to one minute or less"
sed -i 's/^\#*LoginGraceTime .*/LoginGraceTime 20/g' /etc/ssh/sshd_config

echo "5.2.19 Ensure SSH warning banner is configured"
sed -i 's/^\#*Banner .*/Banner \/etc\/issue\.net/g' /etc/ssh/sshd_config

echo "5.2.20 Ensure SSH PAM is enabled"
sed -i 's/^\#*UsePAM .*/UsePAM yes/g' /etc/ssh/sshd_config

echo "5.2.21 Ensure SSH AllowTcpForwarding is disabled"
sed -i 's/^\#*AllowTcpForwarding .*/AllowTcpForwarding no/g' /etc/ssh/sshd_config

echo "5.2.22 Ensure SSH MaxStartups is configured"
sed -i 's/^\#*MaxStartups .*/MaxStartups 5:30:20/g' /etc/ssh/sshd_config

echo "5.2.23 Ensure SSH MaxSessions is set to 4 or less"
sed -i 's/^\#*MaxSessions .*/MaxSessions 3/g' /etc/ssh/sshd_config

echo "Reloading the SSH server configuration..."
systemctl reload sshd
