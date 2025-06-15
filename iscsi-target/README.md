# Steps to configure a linux box to be iscsi taget to test with vsphere
- Pre-requisite
    A logical volume to back the iscsi target called "remote_disk1"

```
dnf install targetd targetcli
systemctl enable --now targetd
targetcli

# define the backing storage
(targetcli) > /backstores/block create name=remote_disk1 dev=/dev/mapper/fedora-remote_disk1

# create the iscsi iqn - i allowed system to generate the target iqn
(targetcli) > /iscsi create 

# Add a lun to the tpg1 of the iscsi taret pointing to the backstore create earlier
(targetcli) >  /iscsi/IQN/tpg1/luns create /backstores/block/remote_disk1


# Actually default setting is to auto-save upon exit
(targetcli) > / saveconfig
(targetcli) > exit


# IMPORTANT: libvirt zone!!
firewall-cmd --add-service=iscsi-target --zone=libvirt  --permanent 
firewall-cmd --reload


# After configuiring the esx11 software isci adapter, get its iqn so that 
# we can add acl to authorize access
targetcli
(targetcli) /iscsi/IQN/tpg1/acls create wwn=IQN_ESX11 
(targetcli) > / saveconfig
(targetcli) > exit


```
