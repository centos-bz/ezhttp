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

#大写转换成小写
upcase_to_lowcase(){
words=$1
echo $words | tr [A-Z] [a-z]
}


uninstall(){
	if [ ! -s "/tmp/ezhttp_info_do_not_del" ];then
		echo "/tmp/ezhttp_info_do_not_del not found,uninstall failed."
		exit 1
	fi
	. /tmp/ezhttp_info_do_not_del
	[ "$depends_prefix" != "" ] && echo "removing depends components.." && rm -rf "$depends_prefix" && echo "Sucess" 
	[ "$nginx_location" != "" ] && echo "uninstalling nginx" && /etc/init.d/nginx stop && rm -rf "$nginx_location"  && echo "Sucess" 
	[ "$apache_location" != "" ] && echo "uninstalling apache" && /etc/init.d/httpd stop && rm -rf "$apache_location"  && echo "Sucess" 
	[ "$mysql_location" != "" ] && echo "uninstalling mysql" && /etc/init.d/mysqld stop && rm -rf "$mysql_location"  && echo "Sucess" 
	[ "$php_location" != "" ] && echo "uninstalling php" && /etc/init.d/php-fpm stop && rm -rf "$php_location"  && echo "Sucess"
	[ "$memcached_location" != "" ] && echo "uninstalling memcached" && /etc/init.d/memcached stop && rm -rf "$memcached_location"  && echo "Sucess"
	[ "$pureftpd_location" != "" ] && echo "uninstalling pureftpd" && /etc/init.d/pureftpd stop && rm -rf "$pureftpd_location"  && echo "Sucess"
	chattr -a /tmp/ezhttp_info_do_not_del && rm -f /tmp/ezhttp_info_do_not_del
}

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


