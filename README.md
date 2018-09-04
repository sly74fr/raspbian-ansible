raspian-ansible
===============

Collection of Ansible roles to set a Raspberry Pi up.

License
=======

GNU GPL3 : see [LICENSE](../master/LICENSE)

Goodies are also greatly appreciated if you feel like rewarding the job :)

Documentation
=============

## Flashing SD card content from a Mac
```console
diskutil list # -> DISK=/dev/diskXXX
DISK=/dev/diskXXX
diskutil unmountDisk $DISK
sudo diskutil partitionDisk $DISK 1 MBR "Free" "%noformat%" 100%
sudo dd bs=1m if=2018-06-27-raspbian-stretch-lite.img of=$DISK conv=sync
touch /Volumes/boot/ssh
diskutil unmountDisk $DISK
diskutil eject $DISK
```

## Changing Raspberry Pi user 'pi' default password
```console
ssh pi@XXX.XXX.XXX.XXX
passwd
```

## Setting up Raspberry Pi OS from a Mac with Ansible
```console
pip install --upgrade pip
pip install ansible==2.6.2
cd raspian-ansible/
ansible-playbook -i YOUR_INVENTORY setup.yml -kK -f 10 # At least once !
```

## Updating Raspberry Pi DHCP settings from a Mac with Ansible
```console
cd raspian-ansible/
ansible-playbook -i YOUR_INVENTORY dhcp.yml -kK -f 10  # Each time DHCP settings are should be updated
```

## Updating Raspberry Pi date and time from a Mac with Ansible
```console
cd raspian-ansible/
ansible-playbook -i YOUR_INVENTORY date.yml -kK -f 10  # Each time date should be updated
```
