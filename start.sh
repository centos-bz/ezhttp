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

#配置linux
main(){
#开始载入
load_functions config
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

#创建记录安装路径信息文件
touch /tmp/ezhttp_info_do_not_del
#不允许删除，只允许追加
chattr +a /tmp/ezhttp_info_do_not_del	
clear
echo "#############################################################################"
echo
echo "You are welcome to use this script to deploy your linux,hope you like."
echo "The script is written by Zhu Maohai."
echo "If you have any question."
echo "please visit http://www.centos.bz/ezhttp/ and submit your issue.thank you."
echo
echo "############################################################################"
echo
need_root_priv
load_config
pre_setting
}

########从这里开始运行程序######
rm -f /root/ezhttp.log
main 2>&1 | tee -a /root/ezhttp.log
