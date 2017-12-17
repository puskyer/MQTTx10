#!/bin/bash -e
#
# /etc/init.d/mqtt: Start the mqtt detection
#
### BEGIN INIT INFO
# Provides:	  mymqtt
# Required-Start: $local_fs $syslog $remote_fs
# Required-Stop: $remote_fs
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start mymqtt detection
# Description: loads mymqtt and assigns privileges
### END INIT INFO

# Ported to new debian way using sh and /lib/lsb/init-functions
# by Angel Carpintero <ack@telefonica.net>
# Modified by : Juan Angulo Moreno <juan@apuntale.com>
#               Eddy Petrisor <eddy.petrisor@gmail.com>
#               ArAge <ArAge@gmx.co.uk>

NAME=mqtt
PATH_BIN=/bin:/usr/bin:/sbin:/usr/sbin
DAEMON=/usr/local/bin/mymqtt.sh
#DEFAULTS=/etc/default/$NAME
DESC="mqtt detection daemon"

ENV="env -i LANG=C PATH=$PATH_BIN"

#. /lib/lsb/init-functions

test -x $DAEMON || exit 0

RET=0

#
case "$1" in
  start)

	if ! [ -d /var/run/mqtt ]; then
            mkdir -m 02750 /var/run/mqtt
            chown root:adm /var/run/mqtt
	fi
	$DAEMON &
	echo $! >/var/run/mqtt/mymqtt.pid

	;;

  stop)
    log_daemon_msg "Stopping $DESC" "$NAME"
#    sudo kill  `cat /var/run/mqtt/mymqtt.pid`
    sudo kill  `pidof -cx mosquitto_sub`
    sudo kill  `pidof -cx /usr/local/bin/mymqtt.sh`

    ;;

  restart)
    $0 stop
    $0 start
    ;;

 # status)
 #   status_of_proc 
 #   ;;

  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart|status}"
    RET=1
    ;;
esac

exit $RET
