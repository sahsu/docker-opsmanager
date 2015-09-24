#!/usr/bin/bash -x

postfix start
#check mms status
MMS=/etc/init.d/mongodb-mms
MMSBACKUP=/etc/init.d/mongodb-mms-backup-daemon

until [ `$MMS status | grep OK > /dev/null; echo $?` -eq 0 ]; do $MMS start; done
until [ `$MMSBACKUP status | grep OK > /dev/null; echo $?` -eq 0 ]; do $MMSBACKUP start; done
