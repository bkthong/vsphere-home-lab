#!/bin/bash
# Creates the esx11 vm
#
# - NIC model needs to be e1000e as virtio not detected by esx
# - disk bus needs to be "sata", virtio and scsi not detected by esx
# - Allocating 16GB of ram as vcenter would require 14GB as vm appliance
# - "--cpu host-passthrough" is important to expose the physical machine cpu to 
#   the esxi vm
# - Would need to give more storage for data store as a separate disk (DONE)
# - To also have separate nics for clustering and etc (FUTURE todo)
#
# Ref: https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-esxi-801-installation-setup-guide.pdf
virt-install \
              --name esx11 \
              --memory 16384 \
              --vcpus 2 \
              --cpu host-passthrough \
              --boot uefi \
              --machine q35 \
              --disk size=50,target.bus=sata \
              --disk size=30,target.bus=sata \
              --cdrom /isos/VMware-VMvisor-Installer-8.0U2-22380479.x86_64.iso \
              --network network=default,model=e1000e \
              --osinfo rhel8.2

