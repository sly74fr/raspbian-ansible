#/bin/sh

dest="$HOME/Logs"
name=("Foo" "Bar")

# Read configuration file to overload previous variables
source $1 # Configuration file
if [ $? -ne 0 ]
then
    exit 1
fi

# Test LOCK file existance first
locker="$dest/LOCK"
if [ ! -f $locker ]
then
    echo "No LOCK file found, nothing to stop then !"
    exit 0
fi

name_size=${#name[@]}
size=`expr $name_size - 1`
for i in `seq 0 $size`
do
    n=`eval echo \${name[$i]}`
    echo "Stopping '$n' log."
    screen -X -S $n quit
done

rm -f $locker

exit 0
