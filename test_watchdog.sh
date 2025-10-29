#!/bin/bash
#   Test process monitoring
#   Written by: Andrey Pershin
LOG_FILE='/var/log/monitoring.log'
PIDFILE='/run/test.pid'
LAST_PID=0

    if [ -e $PIDFILE ]; then
        LAST_PID=$(cat $PIDFILE)
    fi

    if PID=$(pgrep test); then
        if ! curl -fsS https://test.com/monitoring/test/api > /dev/null 2>&1; then
            echo "$(date '+%F %T') Monitoring server unavailable" >> $LOG_FILE
        fi
        if [ $PID -ne $LAST_PID ] && [ $LAST_PID -ne 0 ]; then
            echo "$(date '+%F %T') Process 'test' was restarted with $PID" >> $LOG_FILE
        fi
        echo "$PID" > $PIDFILE
    fi
