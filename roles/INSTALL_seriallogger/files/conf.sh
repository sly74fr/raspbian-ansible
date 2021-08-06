#/bin/sh

tio="$HOME/tio/src/tio"

dest="$HOME/Logs/Test_MMC_v71"

name=("IPMC" "IOIF" "AMC2" "AMC3")

dev_prefix="/dev/serial/by-id/usb-FTDI_TTL232R-3V3_"
dev_suffix="-if00-port0"
dev=("${dev_prefix}FTHBSUJF${dev_suffix}" "${dev_prefix}FTHBVLFH${dev_suffix}" "${dev_prefix}FTAK2D0W${dev_suffix}" "${dev_prefix}FTHBSX4H${dev_suffix}")

baud=("115200" "115200" "19200" "19200")
