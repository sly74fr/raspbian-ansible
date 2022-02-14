#/bin/sh

tio="$HOME/TIO/tio/build/src/tio"

dest="$HOME/Logs/Test_MMC_v72"

name=("IPMC" "AMC")

dev_prefix="/dev/serial/by-id/usb-FTDI_TTL232R-3V3_"
dev_suffix="-if00-port0"
dev=("${dev_prefix}FTHBUF0N${dev_suffix}" "${dev_prefix}FTAK3DC0${dev_suffix}")

baud=("115200" "19200")

joker="/home/pi/Beagle/beagle-api-linux-armhf-v5.40/c/_output/capture_i2c_LAPP 128 0"
