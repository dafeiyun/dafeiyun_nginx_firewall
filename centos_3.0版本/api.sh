#!/bin/bash
CRTDIR=$(cd $(dirname $0); pwd)
echo $CRTDIR
echo $( ps -ef | grep 'dafeiyun_fw_api' | grep -v grep | awk '{print $2}' )
pid=$( ps -ef | grep 'dafeiyun_fw_api' | grep -v grep | awk '{print $2}' )
echo $pid
kill $pid
nohup  $CRTDIR/dafeiyun_fw_api > $CRTDIR/log.file 2>&1 &