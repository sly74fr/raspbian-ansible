#/bin/sh

tio=`which tio`
dest="$HOME/Logs"
name=("Foo" "Bar")
dev=("/dev/ttyUSB0" "/dev/ttyUSB1")
baud=("115200" "19200")

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
    if [ -s $LOCKER ] # Display the message in the LOCK file if any
    then
        echo "========="
        cat $locker
        echo "========="
    fi
    echo "Please RESPONSIVLY use the stop_all.sh script first, then relaunch $0."
    exit -1
fi

# Create new directory
now=`date "+%Y.%m.%d.%H.%M.%S"`
full="$dest/$now/"
echo $full
mkdir -p ${full}
if [ $? -ne 0 ]
then
    exit 3
fi
ln -sfn $full $dest/CURRENT # Update CURRENT symlink to newly created directory

# Assert configuration arrays coherence
name_size=${#name[@]}
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
    exit 4
fi    

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
        #exit 5
    else
        file=$full/$n.log
        screen -d -S $n -m $tio -b $b -t -l $file $d
        if [ $? -ne 0 ]
        then
            exit 6
        fi
        echo "Logging '$n' ($d) at $b bauds in '$file'."
    fi
done

touch $locker

exit 0