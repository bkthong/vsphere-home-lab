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
              --cdrom /isos/VMware-VMvisor-Installer-8.0U2-22380479.x86_64.iso \
              --network network=default,model=e1000e \
              --osinfo rhel8.2

