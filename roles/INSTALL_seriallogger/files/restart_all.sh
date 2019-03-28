#/bin/sh

killall -q tio

now=`date "+%Y.%m.%d.%H.%M.%S"`
mkdir $now

for logger in FTAOFBW6 FTAOFC08 FTAOFEDQ FTAOFERL
do
    device="/dev/serial/by-id/usb-FTDI_TTL232R-3V3_$logger-if00-port0"
    file=$now/$logger.txt
    echo "Logging $device in $file."
	screen -d -m tio -t -l $file -b 19200 $device
done
