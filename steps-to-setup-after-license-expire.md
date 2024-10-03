
1. Create esx11 and esx12 kvm virtual machiens vai the create-esx1{1,2}.sh scripts
2. Perform esxi install on both using the 50GB first disk
3. Once esx11 and 12 are up , configure
    - mgmt interface ip to use static ip
    - update dns and hostname
    - enable esxi shell and ssh
4. Configure esx11 to use the pre-configures iscsi target on host as a VMFS datastore
    - data store name: "iscsi-ds" (I hard coded into the myvcsa.json file)
    - need to update iscsi target ACL to allow the iscsi iqn access
    - browse the iscsi-ds datastore and cleanup uncessary folders 
5. Startup rocky vm which has the VCSA ISO and copy in latest myvcsa.json response file
6. Perform the vcs deployment 
    - use a tmux session as the deployment takes time
    - mount the vcsa iso file
    - follow steps in README file in /vcsa-cli-template/ folder

7. Configure iscsi-ds on esx12 as well
