#!/bin/bash
netstat -n -t | grep $1 | awk '{print $4"\t"$5}' >/proc/net/dafeiyun_fw