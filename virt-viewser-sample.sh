# Sample command to open the vm console remapping the hotkeys to prevent conflict 
# with esxi host dcui short-cut keys
virt-viewer --hotkeys=toggle-fullscreen=shift+f10,release-cursor=shift+f12 --connect qemu:///system esx11

