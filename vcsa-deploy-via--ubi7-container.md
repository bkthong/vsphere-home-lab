[20250622]
# Using ubi7 container to deploy vcsa instead of a vm.
# - more lightweight and convenient
# - need to install iputils, libnsl already instaled in ubi7

# container processes cannot access read-only mounted isos

tmux
sudo setenforce 0 

# download container to install libnsl2 and run vcsa insaller
# tried minimal and micro, but needed much more software for vcsa
# insaller. So using ubo standard instead
# tried with ubi9:latest , error
# ubi7 has libnsl.so.1 and not using lib.nsl.2
podman pull registry.access.redhat.com/ubi7

#/mnt is where vcsa iso is mounted
# ~/vcsa-temp is where my custom myvcsa.json file is
podman run -it -v /mnt:/mnt -v ~/vcsa-temp/:~/vcsa-temp registry.access.redhat.com/ubi9-minimal:latest


(container) > dnf install iputils
(container) > cd /mnt/vcsa-cli-installer/
(container) > lin64/vcsa-deploy install --accept-eula --verify-template-only  ~/vcsa-temp/myvcsa.json
(container) > lin64/vcsa-deploy install --accept-eula --precheck-only  ~/vcsa-temp/myvcsa.json
(container) > lin64/vcsa-deploy install --accept-eula ~/vcsa-temp/myvcsa.json
--> if using tmux , can detach and logout while installer runs

(container) > exit

sudo setenforce 1

(exit tmux)


