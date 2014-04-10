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

#载入函数
load_functions(){
	local function=$1
	if [[ -s $cur_dir/function/${function}.sh ]];then
		. $cur_dir/function/${function}.sh
	else
		echo "$cur_dir/function/${function}.sh not found,shell can not be executed."
		exit 1
	fi	
}

#开始载入
load_functions define
load_functions public
load_functions apache
load_functions depends
load_functions mysql
load_functions nginx
load_functions other-soft
load_functions php
load_functions php-modules
load_functions tools
load_functions other
load_functions upgrade


#开始执行脚本
rm -f /root/ezhttp_errors.log
deploy_linux 2>&1 | tee -a /root/ezhttp_errors.log
