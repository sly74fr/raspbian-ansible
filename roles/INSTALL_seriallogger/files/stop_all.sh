#/bin/sh

set -e  # Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -u  # Attempt to use undefined variable outputs error message, and forces an exit
set -o pipefail  # Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
### set -x  # Similar to verbose mode (-v), but expands commands

joker=""

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
if [ $name_size == 0 ]
then
    echo "ERROR> name array is empty !"
    exit 2
fi    
size=`expr $name_size - 1`
for i in `seq 0 $size`
do
    n=`eval echo \${name[$i]}`
    echo "Stopping '$n' log."
    screen -X -S $n quit
done

echo "Stopping 'JOKER' log."
sudo screen -X -S JOKER quit

rm -f $locker

exit 0
