#/bin/sh

tio="$HOME/tio-master/src/tio"

dest="$HOME/Logs/Test_MMC_v71"

name=("IPMC" "IOIF" "AMC1" "AMC2" "AMC3" "AMC4")

dev_prefix="/dev/serial/by-id/usb-FTDI_TTL232R-3V3_"
dev_suffix="-if00-port0"
dev=("${dev_prefix}FTHBSUJF${dev_suffix}" "${dev_prefix}FTHBVLFH${dev_suffix}" "${dev_prefix}FTBRZJY3${dev_suffix}" "${dev_prefix}FTBS0YM9${dev_suffix}" "${dev_prefix}FTFMFDFT${dev_suffix}" "${dev_prefix}FTAK2D0W${dev_suffix}")

baud=("115200" "115200" "19200" "19200" "19200" "19200")
