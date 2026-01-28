#/bin/bash

### WARNING: 'set -e' causes 'SIZE=`expr $NAME_SIZE - 1`' to stop execution unexepectidly, because it does not return 0 !!!

### set -e  # Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
### set -u  # Attempt to use undefined variable outputs error message, and forces an exit
### set -o pipefail  # Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
### set -x  # Similar to verbose mode (-v), but expands commands

JOKER=""

# Read configuration file to overload previous variables
source $1 # Configuration file
if [ $? -ne 0 ]
then
    exit 1
fi

# Test LOCK file existance first
LOCKER="$DEST/LOCK"
if [ ! -f $LOCKER ]
then
    echo "No LOCK file found, nothing to stop then !"
    exit 0
fi

NAME_SIZE=${#NAME[@]}
if [ $NAME_SIZE == 0 ]
then
    echo "ERROR> name array is empty !"
    exit 2
fi
echo OK

SIZE=`expr $NAME_SIZE - 1`
for i in `seq 0 $SIZE`
do
    N=`eval echo \${NAME[\$i]}`
    echo "Stopping '$N' log."
    screen -X -S $N quit >/dev/null 2>&1 || true
done

if ! test -z "$JOKER"
then
    echo "Stopping 'JOKER' log."
    sudo screen -X -S JOKER quit >/dev/null 2>&1 || true
fi

rm -f $LOCKER
echo "LOCK file removed."

exit 0
