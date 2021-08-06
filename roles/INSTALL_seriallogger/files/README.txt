Welcome to the Serial Logger README file !

INTRO:
The purpose of this tool is to log to file any data incoming on serial ports.

USAGE:
To start logging, use the `start_all.sh` script. It will:
 * read the configuration file you specify as first argument to define which `tio` executable to use, the destination path for the logs, and the names, devices and baud rates to use (please see conf.sh for a full example);
 * assert that there is no LOCK file existing, to prevent ruining an already ongoing test;
 * create a new horodated directory in the destination path (symbolically aliased to CURRENT for your convenience);
 * start (and detach using `screen`) one `tio` process per serial device defined in the given configuration file;
 * create a LOCK file.

To stop logging, use the `stop_all.sh` script. It will:
 * read the configuration file you specify as first argument to define`screen` session to end;
 * check there is a LOCK file existing, to assert an ongoing test;
 * stop all corresponding `screen` dettached sessions, thus killing all attached `tio` processes;
 * remove the LOCK file.
