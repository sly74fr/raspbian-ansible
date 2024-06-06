raspbian-ansible
================

Collection of Ansible roles to set up a Raspberry Pi (or any Debian by the way) from scratch.

License
=======

GNU GPLv3 : see [LICENSE](../master/LICENSE)

Goodies are also greatly appreciated if you feel like rewarding the job :)

Documentation
=============

## Flashing an SD card from a Mac
```console
diskutil list # -> DISK=/dev/diskXXX
DISK=/dev/diskXXX
diskutil unmountDisk $DISK
sudo diskutil partitionDisk $DISK 1 MBR "Free" "%noformat%" 100%
sudo dd bs=1m if=2024-03-15-raspios-bookworm-arm64-lite.img of=$DISK status=progress
diskutil unmountDisk $DISK
diskutil eject $DISK
```

For further customization, please have a look at the [official Raspberry Pi documentation](https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi).

## Applying setup.yml from a Mac with Ansible
```console
pip install --upgrade pip
pip install ansible==2.6.2
git clone https://github.com/sly74fr/raspbian-ansible.git
cd raspbian-ansible/
ansible-playbook -i YOUR_INVENTORY setup.yml -kK -f 10 # At least once !
```
