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

while true
do
	read -p "Are you sure uninstall ezhttp(include nginx apache mysql php memcached pureftpd etc.)? [N/y]? " uninstall
	uninstall="`upcase_to_lowcase $uninstall`"
	case $uninstall in
	y) uninstall ; break;;
	n) break;;
	*) echo "input error";;
	esac
done


uninstall(){
	if [ ! -s "/tmp/ezhttp_info_do_not_del" ];then
		echo "/tmp/ezhttp_info_do_not_del not found,uninstall failed."
		exit 1
	fi
	. /tmp/ezhttp_info_do_not_del
	[ $depends_prefix != "" ] && echo "removing depends components.." && rm -rf "$depends_prefix" && echo "Sucess" | echo "failed."
	[ $nginx_location != "" ] && echo "uninstalling nginx" && rm -rf "$nginx_location"  && echo "Sucess" | echo "failed."
	[ $apache_location != "" ] && echo "uninstalling apache" && rm -rf "$apache_location"  && echo "Sucess" | echo "failed."
	[ $mysql_location != "" ] && echo "uninstalling mysql" && rm -rf "$mysql_location"  && echo "Sucess" | echo "failed."
	[ $php_location != "" ] && echo "uninstalling php" && rm -rf "$php_location"  && echo "Sucess" | echo "failed."
	[ $memcached_location != "" ] && echo "uninstalling memcached" && rm -rf "$memcached_location"  && echo "Sucess" | echo "failed."
	[ $pureftpd_location != "" ] && echo "uninstalling pureftpd" && rm -rf "$pureftpd_location"  && echo "Sucess" | echo "failed."
	[ $apache_location != "" ] && echo "uninstalling apache" && rm -rf "$apache_location"  && echo "Sucess" | echo "failed."
	chattr -a /tmp/ezhttp_info_do_not_del && rm -f /tmp/ezhttp_info_do_not_del
}