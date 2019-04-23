Welcome to the Serial Logger README file !

INTRO:
The purpose of this tool is to log to file any data incomming on serial ports.

USAGE:
To (re)start logginig, use the `restart_all.sh` script. It will:
 * check there is no LOCK file existing, to prevent ruinin an already ongoing test;
 * kill all running `tio` instances;
 * start (and detach using `screen`) one `tio` (19200 baud) process per FTDI id present in the script itself;
 * create a LOCK file.

To query all ongoing connection, the `query_all.sh` script echoes an 'i\r' character sequence to each per FTDI id present in the script itself.

TODO:
 * Move "FTDI IDs / File Name / Connection Speed" from inside the scripts to a dedicated configuration file;
 * Investigate ICARE logging '?' garbage;
 * Update/fix `tio` to remove `screen` dependency.

