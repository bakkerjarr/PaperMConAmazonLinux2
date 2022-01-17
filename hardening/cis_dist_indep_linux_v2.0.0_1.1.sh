#!/bin/bash
# Harden the host as per the CIS Distribution Independent Linux Benchmark
# v2.0.0 - 07-16-2019 benchmark.
# This script focuses on section 1.1 of the benchmark:
# Initial Setup - Filesystem Configuration

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as the root user! Exiting..."
  exit
fi

echo "This script is now going to apply the hardening recommendations from \
section 1.1 (Initial Setup - Filesystem Configuration) for the CIS \
Distribution Independent Linux Benchmark v2.0.0 - 07-16-2019 benchmark."

echo "1.1.1.1 Ensure mounting of cramfs filesystems is disabled"
echo "install cramfs /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.2 Ensure mounting of freevxfs filesystems is disabled"
echo "install freevxfs /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.3 Ensure mounting of jffs2 filesystems is disabled"
echo "install jffs2 /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.4 Ensure mounting of hfs filesystems is disabled"
echo "install hfs /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.5 Ensure mounting of hfsplus filesystems is disabled"
echo "install hfsplus /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.6 Ensure mounting of squashfs filesystems is disabled"
echo "install squashfs /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.7 Ensure mounting of udf filesystems is disabled"
echo "install udf /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.1.8 Ensure mounting of FAT filesystems is limited"
echo "install vfat /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf

echo "1.1.15 Ensure nodev option set on /dev/shm partition"
echo "1.1.16 Ensure nosuid option set on /dev/shm partition"
echo "1.1.17 Ensure noexec option set on /dev/shm partition"
cp -a /etc/fstab /etc/fstab.`date +%F`_pre-cis_section_1_hardening
echo "tmpfs /dev/shm tmpfs defaults,noexec,nodev,nosuid,seclabel 0 0" >> /etc/fstab

echo "1.1.21 Ensure sticky bit is set on all world-writable directories"
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -I '{}' chmod a+t '{}'

echo "1.1.23 Disable USB Storage"
echo "install usb-storage /bin/true" >> /etc/modprobe.d/cis_hardening_disabled_filesystems.conf
