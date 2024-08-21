#!/bin/bash
# Creates the esx11 vm
#
# - NIC model needs to be e1000e as virtio not detected by esx
# - disk bus needs to be "sata", virtio and scsi not detected by esx
# - Allocating 16GB of ram as vcenter would require 14GB as vm appliance
# - "--cpu host-passthrough" is important to expose the physical machine cpu to 
#   the esxi vm
# - Would need to give more storage for data store as a separate disk (DONE)
# - Increased second disk for data store from 30Gb to 100GB as not enough
#   to deploy vcsa (25GB even with thin provisioning option chosen)
# - To also have separate nics for clustering and etc (FUTURE todo)
#
#[20240821]
# - Added option: --network network=vmotion-isolated....
#   REQUIRES a second isolated network on virt environment to work
# - Also updated to use 4 vcpus
#
# Ref: https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-esxi-801-installation-setup-guide.pdf
virt-install \
              --name esx11 \
              --memory 16384 \
              --vcpus 4 \
              --cpu host-passthrough \
              --boot uefi \
              --machine q35 \
              --disk size=50,target.bus=sata \
              --disk size=100,target.bus=sata \
              --cdrom /isos/VMware-VMvisor-Installer-8.0U2-22380479.x86_64.iso \
              --network network=default,model=e1000e \
              --network network=vmotion-isolated,model=e1000e \
              --osinfo rhel8.2

