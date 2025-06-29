
## Installing Virtualization (KVM/libvirt)

```
# dnf group install virtualization
# systemctl start libvirtd.service
# cat /sys/module/kvm_intel/parameters/nested
  --> ensure nested virtualization allowed
```
---

## Setting up the default virtual network

esx11 - esx11.bkhome.com - 192.168.122.11
esx12 - esx12.bkhome.com - 192.168.122.12

Also a second private network for vmotion dedicated traffic

1. Edit the libvirt default network:
   -  Reduce dhcp range from .2 - .254  to .20 - .254
      (to use static ip for esx host)
   - Update the dnsmaq domain for libvirt
   ```
          <domain name='bkhome.com' localOnly='yes'/>
   ```
   - map hostnames to dns, just after the <ip ..> section
   ```
        <dns>
          <host ip='192.168.122.11'>
            <hostname>esx11.bkhome.com</hostname>
          </host>
          <host ip='192.168.122.12'>
            <hostname>esx12.bkhome.com</hostname>
          </host>
        </dns>
   ```
   - restart the default libvirt network

```
   # virsh net-edit default
   # virsh net-destroy default
   # virsh net-start default
```

  > When should point the esx1{1,2} DNS to 192.168.122.1 (libvirt's default network
    dnsmasq is listening on

  CREATE second network for vmotion:
    - enable cockpit and install cockpit-machines and configure network thru web
        - name: vmotion-isolated
        - isolated
        - ip ragge: 192.168.100.*/24 (did not enable dhcp range)
    - Activate the "vmotion-isolated" network

2. Place the VMVisor-xxx.iso in /isos folder 
   (path hard coded in  create-esx11.sh script)

3. As root, run the create-esx11.sh script to start the installation
    

4. Setup the esx host in the UI (if using virt-viewer, release cursor by
   pressing shift-f12)

   > Better method is local port forwarding 5900 (~/.ssh/config)
     LocalForward 5900 127.0.0.1:5900  #esx11 ?  -L 5900:127.0.0.1:5900
     LocalForward 5901 127.0.0.1:5901  #esx12 ?  -L 5901:120.0.0.1;5901

   Then use "remote" GUI tool on own laptop  and open url 
            spice"://localhost:5900 
   which is port forwarded to the remote host and you can see the 
   console of esx11/12

   ```
   remote-viewer --hotkeys=toggle-fullscreen=shift+f10,release-cursor=shift+f12 spice://localhost:5900
   ```

5. Use the esx console to set static IP for mgmt interface:  
   - 192.168.122.11/24, 192.168.122.1 (gw)

6. Update the hostname and fqdn 
   (multiple methods available, but using esxcli here)
   - F2 at esx console to configure
   - Troubleshooting --> Enable shell
   - alt-f1 to switch to shell
   - login
   
   ```
   esxcli system hostname set --host=esx11
   esxcli system hostname set --fqdn=esx11.bkhome.com
   ```

   Ref: https://kb.vmware.com/s/article/1010821

   > It is also possible to set the hostname at the console   
       - management interface --> dns --> hostname --> esx11


7. Add the second 30GB disk as a data store
   - https://192.168.122.11
     - Storage - New Data Store
        - name: <name>
        - vmfs version: vmfs6

8. On host fedora consider installing ksmtuned and their services

   ```
   dnf install ksmtuned
   systemctl start ksmtuned.service #enabled by default
   ```

## Add a iscsi data store
1. Follow steps in iscsi-target/ folder to create the iscssi target on host 

2. Define the iscsi data store on esx11 (and later esc12)
    - esx11 console
    - storage -> Adapters -> Software iscsi 
        - Choose enabled (radio button)
        - Add dynamic target: 
            192.168.122.1 (ip address of host)
        - REFRESH
            -> vmhba64 (appears)
3. Go back to iscsi server (for met targetcli)
   and update the ACL to allow the esx11 initiator name obtained
   from the iscsi sofwareware adapter details
   - need to rescan adapter, i also hit error and needed
     to logout from esx11 console and relogin
   - if all goes weel, under "devices" we will see the ISCSI disk appear


3. Define new data store 
    - name: iscsi-data
    - device: LIO-*ISCSI*-

## Setup nfs data store
1. Using host machine /isos as nfs server share

```
dnf install nfs-utils
systemctl enable --now nfs-server.service
vim /etc/exports.d/isos.exports
  - rw, no_root_squash
```
2. On host, open 2049/tcp

```
firewall-cmd --add-service=nfs --zone=libvirt --permanent
firewall-cmd --reload
```

3. Login to esx11 and create a nfs4 data store 192.168.122.1:/isos

## Update esxi license from VCI
- Deploying vcsa on esxi free 8u3 hits error.
- need to update license from VCI comminity

1. ESX11 console
2. manage -> licensing --> assign license
3. enter license key obtained from vci communityo
   - look for  "VMware vSphere 8 Enterprise Plus for 32 processors"
4. Assign license


## Setting up VCSA on as an embedded appliance on esxi

> Note: 20250629  
  Now i'm using a **rhel7 container** instead to solve
  the libnsl problem. Refer to 'vcsa-deploy-via--ubi7-container.md
  on the steps

> UI and CLI methods available for installint VCSA. Here
  I outline the steps using the CLI method with the template
  in this git repo

1. Have a Rocky 9.2 machine/vm available to act as install client
   - The libnsl library on Fedora Server 39 gave problems. 
   - Hence using Rocky 9.2 as I know the libnsl works well with the
     VCSA installer
   - NOTE: on 20250615- tried to use fedora 42 host without having to use
     a rocky vm to run the installer, hit the same libnsl problem


2. Copy the VCSA iso into the rocky 9.2 machine
3. Loop mount the ISO to /mnt (or other suitable mnt point)
4. Update the template if neccessary:   
   (vcsa-cli-template/myvcsa.json file in this gir-repo)
    - IP address of the new VCentre server hard coded as 192.168.122.50
    - NTP using asia's ntp pool
    - use the iscsi data store created on esx11
        - (OLD) Existing esxi data store "hard coded as ssd" (OLD) 
    - ...
5. Copy the myvcsa.json template to the Rocky 9.2 machine user's home dir

4. Commands:

```
 cd /mnt/vcsa-cli-installer/

 # Check syntax of the template (if changes made)
 lin64/vcsa-deploy install --accept-eula --verify-template-only  ~/myvcsa.json

 # Run pre-check
 lin64/vcsa-deploy install --accept-eula --precheck-only  ~/myvcsa.json

 # Run actual installation. Might want to run in a tmux session if using remote 
 # access
 lin64/vcsa-deploy install --accept-eula ~/myvcsa.json
```
5. Wait for installation to complete
