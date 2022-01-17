#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 3.2 of the benchmark:
# Network Configuration - Network Parameters (Host and Router)

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 3.2 (Network Configuration - Network Parameters (Host and Router)) \
for the CIS Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 \
benchmark."

echo "3.2.1 Ensure source routed packets are not accepted"
echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv6.conf.all.accept_source_route = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.2 Ensure ICMP redirects are not accepted"
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.3 Ensure secure ICMP redirects are not accepted"
echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.4 Ensure suspicious packets are logged"
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.5 Ensure broadcast ICMP requests are ignored"
echo "sysctl net.ipv4.icmp_echo_ignore_broadcasts" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.6 Ensure bogus ICMP responses are ignored"
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.7 Ensure Reverse Path Filtering is enabled"
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.8 Ensure TCP SYN Cookies is enabled"
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf

echo "3.2.9 Ensure IPv6 router advertisements are not accepted"
echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.d/cis_hardening_network_parameters_host_and_router.conf
