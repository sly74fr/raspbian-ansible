#/bin/bash

### WARNING: 'set -e' causes 'SIZE=`expr $NAME_SIZE - 1`' to stop execution unexepectidly, because it does not return 0 !!!

### set -e  # Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
### set -u  # Attempt to use undefined variable outputs error message, and forces an exit
### set -o pipefail  # Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
### set -x  # Similar to verbose mode (-v), but expands commands

### TIO=`which tio`
TIO=~/Serial_Logger/TIO/build/src/tio
JOKER=""

# Read configuration file to overload previous variables
source $1 # Configuration file
if [ $? -ne 0 ]
then
    echo "ERROR> no configuration file found."
    exit 1
fi

# Check tio availability
$TIO --version > /dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "ERROR> tio not found at '$tio' !"
    exit 2
fi
echo -n "$TIO "
$TIO --version | head -1 | cut -d ' ' -f 2

# Test LOCK file existance first
LOCKER="$DEST/LOCK"
if [ -f $LOCKER ]
then
    echo "ERROR: a test is already ongoing !!!"
    if [ -s $LOCKER ] # Display the message in the LOCK file if any
    then
        echo "========="
        cat $LOCKER
        echo "========="
    fi
    echo "Please RESPONSIVLY use the stop_all.sh script first, then relaunch $0."
    exit -1
fi

# Assert configuration arrays coherence
NAME_SIZE=${#NAME[@]}
if [ $NAME_SIZE == 0 ]
then
    echo "ERROR> name array is empty !"
    exit 3
fi    
DEV_SIZE=${#DEV[@]}
if [ $NAME_SIZE != $DEV_SIZE ]
then
    echo "ERROR> arrays size mismatch !"
    exit 4
fi    
BAUD_SIZE=${#BAUD[@]}
if [ $BAUD_SIZE != $DEV_SIZE ]
then
    echo "ERROR> arrays size mismatch !"
    exit 5
fi    

# Create new directory
NOW=`date "+%Y.%m.%d.%H.%M.%S"` 
FULL="$DEST/$NOW"
echo $FULL
mkdir -p ${FULL}
if [ $? -ne 0 ]
then
    exit 6
fi
ln -sfn $FULL $DEST/CURRENT # Update CURRENT symlink to the newly created directory

# Start screened tio
SIZE=`expr $NAME_SIZE - 1`
for i in `seq 0 $SIZE`
do
    N=`eval echo \${NAME[\$i]}`
    D=`eval echo \${DEV[\$i]}`
    B=`eval echo \${BAUD[\$i]}`

    if [ ! -c $D ]
    then
        echo "WARNING> skipping device '$D' not found !"
    else
        FILE=$FULL/$N.log
        screen -d -S $N -m $TIO -b $B $D -c none -t --timestamp-format=iso8601 -l --log-strip --log-file=$FILE
        if [ $? -ne 0 ]
        then
            echo "ERROR> could not start '$N' logger."
            exit 7
        fi
        echo "Logging '$N' ($D) at $B bauds in '$FILE'."
    fi
done

# Start screened JOKER if any
if ! test -z "$JOKER"
then
    FILE=$FULL/JOKER.log
    sudo screen -d -S JOKER -L -Logfile $FILE -m $JOKER
    if [ $? -ne 0 ]
    then
        exit 8
    fi
    echo "Logging '$JOKER' in '$FILE'."
fi

touch $LOCKER

exit 0
