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
echo $words | tr '[A-Z]' '[a-z]'
}

#判断系统版本
check_sys_version(){
if cat /etc/issue | grep -q -E -i "ubuntu|debian";then
	echo "debian"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
	echo "centos"	
elif cat /proc/version | grep -q -E -i "ubuntu|debian";then
	echo "debian"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
	echo "centos"
fi	
}

#关闭开机启动
boot_stop(){
if [ "`check_sys_version`" == "debian" ];then
	update-rc.d -f $1 remove
elif [ "`check_sys_version`" == "centos" ];then
	chkconfig $1 off
fi
}

uninstall(){
	if [ ! -s "/tmp/ezhttp_info_do_not_del" ];then
		echo "/tmp/ezhttp_info_do_not_del not found,uninstall failed."
		exit 1
	fi
	. /tmp/ezhttp_info_do_not_del
	if [ "$depends_prefix" != "" ];then
		echo "removing depends components.."
		rm -rf "$depends_prefix" && echo "Sucess" 
	fi	

	if [ "$nginx_location" != "" ];then
		echo "uninstalling nginx"
		/etc/init.d/nginx stop
		boot_stop nginx
		rm -f /etc/init.d/nginx
		rm -rf "$nginx_location"  && echo "Sucess" 
	fi	

	if [ "$apache_location" != "" ];then
		echo "uninstalling apache"
		/etc/init.d/httpd stop
		boot_stop httpd
		rm -f /etc/init.d/httpd
		rm -rf "$apache_location"  && echo "Sucess" 
	fi
		
	if [ "$mysql_location" != "" ];then
		echo "uninstalling mysql"
		/etc/init.d/mysqld stop
		boot_stop mysqld
		rm -f /etc/init.d/mysqld
		rm -rf "$mysql_location"  && echo "Sucess" 
	fi 
		
	if [ "$php_location" != "" ];then
		echo "uninstalling php"
		/etc/init.d/php-fpm stop
		boot_stop php-fpm
		rm -f /etc/init.d/php-fpm
		rm -rf "$php_location"  && echo "Sucess"
	fi
		
	if [ "$memcached_location" != "" ];then
		echo "uninstalling memcached"
		/etc/init.d/memcached stop
		boot_stop memcached
		rm -f /etc/init.d/memcached
		rm -rf "$memcached_location"  && echo "Sucess"
	fi
		
	if [ "$pureftpd_location" != "" ];then
		echo "uninstalling pureftpd"
		/etc/init.d/pureftpd stop
		boot_stop pureftpd
		rm -f /etc/init.d/pureftpd
		rm -rf "$pureftpd_location"  && echo "Sucess"
	fi
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


