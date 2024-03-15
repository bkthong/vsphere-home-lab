#!/bin/bash
# Creates the esx11 vm
#
virt-install \
              --name esx11 \
              --memory 16384 \
	      --vcpus 2 \
              --boot uefi \
              --machine q35 \
              --disk size=50,target.bus=scsi \
	      --cdrom /home/bk/vsphere/VMware-VMvisor-Installer-8.0U2-22380479.x86_64.iso \
	      --osinfo rhel8.2

