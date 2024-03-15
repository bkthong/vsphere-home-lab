
## Installing Virtualization (KVM/libvirt)

```
# dnf group install Virtualization
# systemctl start libvirtd.service
# cat /sys/module/kvm_intel/parameters/nested
  --> ensure nested virtualization allowed
```
---

## Setting up the default virtual network

esx11 - esx11.bkhome.com - 192.168.122.11
esx12 - esx12.bkhome.com - 192.168.122.12

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

2. Place the VMVisor-xxx.iso in /isos folder 
   (path hard coded in  create-esx11.sh script)

3. As root, run the create-esx11.sh script to start the installation


4. Setup the esx host in the UI (if using virt-viewer, release cursor by
   pressing shift-f12)

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

