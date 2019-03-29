#/bin/sh

for logger in FTAOFBW6 FTAOFC08 FTAOFEDQ FTAOFERL
do
    device="/dev/serial/by-id/usb-FTDI_TTL232R-3V3_$logger-if00-port0"
    echo "Refressing $device."
    echo -e -n 'i\r' > $device
done
