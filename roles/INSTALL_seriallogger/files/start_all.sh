#/bin/sh

set -e  # Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -u  # Attempt to use undefined variable outputs error message, and forces an exit
set -o pipefail  # Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
### set -x  # Similar to verbose mode (-v), but expands commands

tio="./TIO/build/src/tio"
### tio=`which tio`
joker=""

# Read configuration file to overload previous variables
source $1 # Configuration file
if [ $? -ne 0 ]
then
    exit 1
fi

# Check tio availability
$tio --version > /dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "ERROR> tio not found at '$tio' !"
    exit 2
fi
echo -n "$tio "
$tio --version | head -1 | cut -d ' ' -f 2

# Test LOCK file existance first
locker="$dest/LOCK"
if [ -f $locker ]
then
    echo "ERROR: a test is already ongoing !!!"
    if [ -s $locker ] # Display the message in the LOCK file if any
    then
        echo "========="
        cat $locker
        echo "========="
    fi
    echo "Please RESPONSIVLY use the stop_all.sh script first, then relaunch $0."
    exit -1
fi

# Assert configuration arrays coherence
name_size=${#name[@]}
if [ $name_size == 0 ]
then
    echo "ERROR> name array is empty !"
    exit 3
fi    
dev_size=${#dev[@]}
if [ $name_size != $dev_size ]
then
    echo "ERROR> arrays size mismatch !"
    exit 4
fi    
baud_size=${#baud[@]}
if [ $baud_size != $dev_size ]
then
    echo "ERROR> arrays size mismatch !"
    exit 5
fi    

# Create new directory
now=`date "+%Y.%m.%d.%H.%M.%S"`
full="$dest/$now/"
echo $full
mkdir -p ${full}
if [ $? -ne 0 ]
then
    exit 6
fi
ln -sfn $full $dest/CURRENT # Update CURRENT symlink to newly created directory

# Start screened tio
size=`expr $name_size - 1`
for i in `seq 0 $size`
do
    n=`eval echo \${name[$i]}`
    d=`eval echo \${dev[$i]}`
    b=`eval echo \${baud[$i]}`

    if [ ! -c $d ]
    then
        echo "WARNING> skipping device '$d' not found !"
    else
        file=$full/$n.log
        screen -d -S $n -m $tio -b $b $d -c none -t --timestamp-format=iso8601 --log-strip --log-file=$file 
        if [ $? -ne 0 ]
        then
            exit 7
        fi
        echo "Logging '$n' ($d) at $b bauds in '$file'."
    fi
done

# Start sudoed screened joker
if ! test -z "$joker"
then
    file=$full/JOKER.log
    sudo screen -d -S JOKER -L -Logfile $file -m $joker
    if [ $? -ne 0 ]
    then
        exit 8
    fi
    echo "Logging '$joker' in '$file'."
fi

touch $locker

exit 0
