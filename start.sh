#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================
#   SYSTEM REQUIRED:  Linux
#   DESCRIPTION:  automatic deploy your linux
#   AUTHOR: Zhu Maohai.
#   website: http://www.centos.bz/ezhttp/
#===============================================================================

cur_dir=`pwd`

#初始化
if [ -f $cur_dir/init ];then
	. $cur_dir/init
else
	echo "init file not found.shell script can't be executed."
	exit 1
fi
#载入常用函数
if [ -f $cur_dir/func ];then
	. $cur_dir/func
else
	echo "func file not found.shell script can't be executed."
	exit 1
fi	
rm -f /root/ezhttp_errors.log
deploy_linux 2>&1 | tee -a /root/ezhttp_errors.log
