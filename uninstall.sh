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
check_sys(){
	local checkType=$1
	local value=$2

	local release=''
	local systemPackage=''
	local packageSupport=''

	if [[ -f /etc/redhat-release ]];then
		release="centos"
		systemPackage="yum"
		packageSupport=true

	elif cat /etc/issue | grep -q -E -i "debian";then
		release="debian"
		systemPackage="apt"
		packageSupport=true

	elif cat /etc/issue | grep -q -E -i "ubuntu";then
		release="ubuntu"
		systemPackage="apt"
		packageSupport=true

	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
		release="centos"
		systemPackage="yum"
		packageSupport=true

	elif cat /proc/version | grep -q -E -i "debian";then
		release="debian"
		systemPackage="apt"
		packageSupport=true

	elif cat /proc/version | grep -q -E -i "ubuntu";then
		release="ubuntu"
		systemPackage="apt"
		packageSupport=true

	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
		release="centos"
		systemPackage="yum"
		packageSupport=true

	else
		release="unknow"
		systemPackage="unknow"
		packageSupport=false
	fi

	if [[ $checkType == "sysRelease" ]]; then
		if [ "$value" == "$release" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageManager" ]]; then
		if [ "$value" == "$systemPackage" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageSupport" ]]; then
		if $packageSupport;then
			return 0
		else
			return 1
		fi
	fi
}

#关闭开机启动
boot_stop(){
if check_sys sysRelease ubuntu || check_sys sysRelease debian;then
	update-rc.d -f $1 remove
elif check_sys sysRelease centos;then
	chkconfig $1 off
fi
}

uninstall(){
	if [ ! -s "/etc/ezhttp_info_do_not_del" ];then
		echo "/etc/ezhttp_info_do_not_del not found,uninstall failed."
		exit 1
	fi
	. /etc/ezhttp_info_do_not_del
	if [ "$depends_prefix" != "" ];then
		echo "removing depends components.."
		rm -rf "$depends_prefix" && echo "Sucess" 
	fi	

	if [ "$nginx_location" != "" ];then
		echo "uninstalling nginx"
		service nginx stop
		boot_stop nginx
		rm -f /etc/init.d/nginx
		rm -rf "$nginx_location"  && echo "Sucess" 
	fi	

	if [ "$apache_location" != "" ];then
		echo "uninstalling apache"
		service httpd stop
		boot_stop httpd
		rm -f /etc/init.d/httpd
		rm -rf "$apache_location"  && echo "Sucess" 
	fi
		
	if [ "$mysql_location" != "" ];then
		echo "uninstalling mysql"
		service mysqld stop
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
		service memcached stop
		boot_stop memcached
		rm -f /etc/init.d/memcached
		rm -rf "$memcached_location"  && echo "Sucess"
	fi
		
	if [ "$pureftpd_location" != "" ];then
		echo "uninstalling pureftpd"
		service pureftpd stop
		boot_stop pureftpd
		rm -f /etc/init.d/pureftpd
		rm -rf "$pureftpd_location"  && echo "Sucess"
	fi
	chattr -a /etc/ezhttp_info_do_not_del && rm -f /etc/ezhttp_info_do_not_del
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


