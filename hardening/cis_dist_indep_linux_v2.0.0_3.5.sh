#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 3.5 of the benchmark:
# Network Configuration - Firewall Configuration

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 3.5 (Network Configuration - Firewall Configuration) for the CIS \
Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "Before applying the recommendations, this script is going to install \
the iptables-services package so that iptables rules can be persisted and \
automatically load on boot."
yum install -y iptables-services
systemctl enable iptables
systemctl start iptables

# Flush IPtables rules
iptables -F

echo "3.5.2.1 Ensure default deny firewall policy"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

echo "3.5.2.2 Ensure loopback traffic is configured"
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j DROP

echo "3.5.2.3 Ensure outbound and established connections are configured"
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT

echo "3.5.2.4 Ensure firewall rules exist for all open ports"
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

echo "Persisting the iptables rules..."
service iptables save
