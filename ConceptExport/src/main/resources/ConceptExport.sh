#!/bin/bash

PIDFILE=/opt/ConceptExport/ConceptExport.pid

if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo "Process already running"
    exit 1
  else
    ## Process not found assume not running
    echo "No process found with PID"
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]
  then
    echo "Could not create PID file"
    exit 1
  fi
fi


# pull in environment variables for mysql connection to config
. /opt/tomcat/bin/setenv.sh

java -XX:-OmitStackTraceInFastThrow -XX:+CrashOnOutOfMemoryError -jar /opt/ConceptExport/bin/ConceptExport.jar /opt/ConceptExport/ImportData/

rm $PIDFILE
