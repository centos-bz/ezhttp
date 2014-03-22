#提示是否使用上一次的设置
if_use_previous_setting(){
if [ -s "/root/previous_setting" ];then
	#是否使用上次设置安装
	yes_or_no "previous settings found,would you like using the  previous settings from the file /root/previous_setting [Y/n]: " "install_with_pre_settings" "rm -f /root/previous_setting;lanmp_menu"
else
	lanmp_menu
fi

}

#使用上次配置安装
install_with_pre_settings(){
. /root/previous_setting
if [ "$stack" == "lnmp" ];then
	install_lnmp
elif [ "$stack" == "lamp" ];then
	install_lamp
elif [ "$stack" == "lnamp" ];then
	install_lnamp
else
	echo "stack variable not found,exit"
	exit 1
fi	
}

#lanmp菜单
lanmp_menu(){
	echo -e "1) LNMP(Nginx MySQL PHP)\n2) LAMP(Apache MySQL PHP)\n3) LNAMP(Nginx Apache MySQL PHP)\n4) back to main menu\n"
	while true
	do
		read -p "please input the package you like to install: " package
		case $package in
			 1) preinstall_lnmp;install_lnmp;;
			 2) preinstall_lamp;install_lamp;;
			 3) preinstall_lnamp;install_lnamp;;
			 4) clear;pre_setting;;
			 *) echo "input error.";;
		esac
	done
}

#lnmp安装前设置
preinstall_lnmp(){
	#安装前设置
	stack="lnmp"
	php_mode="with_fastcgi"
	nginx_preinstall_settings
	mysql_preinstall_settings	
	php_preinstall_settings
	php_modules_preinstall_settings
	othersoft_preinstall_settings
}

#安装lnmp
install_lnmp(){	
	last_confirm
	#记录设置
	record_setting
	#开始安装
	disable_selinux
	#安装工具
	install_tool

	[ "$nginx" != "do_not_install" ] && check_installed_ask "install_nginx" "$nginx_location"
	[ "$mysql" != "do_not_install" ] && check_installed_ask "install_mysqld" "$mysql_location"
	[ "$php" != "do_not_install" ] && check_installed_ask "install_php" "$php_location"
	[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$php_location"
	[ "$other_soft_install" != "do_not_install" ] && install_other_soft
	post_done
}

#lamp安装前设置
preinstall_lamp(){
	#安装前设置
	stack="lamp"
	php_mode="with_apache"
	apache_preinstall_settings
	mysql_preinstall_settings	
	php_preinstall_settings
	php_modules_preinstall_settings
	othersoft_preinstall_settings
}

#安装lamp
install_lamp(){	
	last_confirm
	#记录设置
	record_setting	
	#开始安装
	disable_selinux
	#安装工具
	install_tool

	[ "$apache" != "do_not_install" ] && check_installed_ask "install_apache" "$apache_location"
	[ "$mysql" != "do_not_install" ] && check_installed_ask "install_mysqld" "$mysql_location"
	[ "$php" != "do_not_install" ] && check_installed_ask "install_php" "$php_location"
	[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$php_location"
	[ "$other_soft_install" != "do_not_install" ] && install_other_soft
	post_done
}


#lnamp安装前设置
preinstall_lnamp(){
	#安装前设置
	stack="lnamp"
	php_mode="with_apache"
	nginx_preinstall_settings
	apache_preinstall_settings
	mysql_preinstall_settings	
	php_preinstall_settings
	php_modules_preinstall_settings
	othersoft_preinstall_settings
}

#安装lnamp
install_lnamp(){	
	last_confirm
	#记录设置
	record_setting	
	#开始安装
	disable_selinux
	#安装工具
	install_tool

	[ "$nginx" != "do_not_install" ] && check_installed_ask "install_nginx" "$nginx_location"
	[ "$apache" != "do_not_install" ] && check_installed_ask "install_apache" "$apache_location"
	[ "$mysql" != "do_not_install" ] && check_installed_ask "install_mysqld" "$mysql_location"
	[ "$php" != "do_not_install" ] && check_installed_ask "install_php" "$php_location"
	[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$php_location"
	[ "$other_soft_install" != "do_not_install" ] && install_other_soft
	post_done
}

#记录设置信息
record_setting(){
#写入设置到临时文件，以备下次重新安装使用
cat >/root/previous_setting <<EOF
stack="$stack"
nginx="$nginx"
nginx_location="$nginx_location"
nginx_configure_args='${nginx_configure_args}'
apache="$apache"
apache_location="$apache_location"
apache_configure_args='${apache_configure_args}'
mysql="$mysql"
mysql_location="$mysql_location"
mysql_data_location="$mysql_data_location"
mysql_root_pass="$mysql_root_pass"
mysql_configure_args='${mysql_configure_args}'
php="$php"
php_location="$php_location"
php_mode="$php_mode"
php_modules_install="${php_modules_install}"
php_configure_args='${php_configure_args}'
other_soft_install="${other_soft_install}"
memcached_location="${memcached_location}"
pureftpd_location="${pureftpd_location}"
phpmyadmin_location="${phpmyadmin_location}"

EOF
#自定义版本时增加变量
echo -e "$custom_info" >> /root/previous_setting
}


#安装前设置
pre_setting(){
#主菜单
while true
do
	#使read能支持回格删除
	stty erase "^H"
	echo -e "1) LAMP LNMP LANMP Installation.\n2) Some Useful Tools.\n3) Exit.\n"
	read -p "please select: " select
	case $select in
	1) echo "you select Pre-installation settings." ; if_use_previous_setting ; break;;
	2) echo "you select tools." ; tools_setting ; break;;
	3) echo "you select exit." ; exit 1;;
	*) echo "input error.";;
	esac
done
}

#完成后的一些配置
post_done(){
echo "start programs..."	
[ "$nginx" != "do_not_install" ] && [ "$stack" != "lamp" ] &&  /etc/init.d/nginx start
[ "$apache" != "do_not_install" ] && [ "$stack" != "lnmp" ] && /etc/init.d/httpd start

if 	[ "$mysql" != "do_not_install" ] &&  [ "$mysql" != "libmysqlclient18" ];then
	#配置mysql
	/etc/init.d/mysqld start
	${mysql_location}/bin/mysqladmin -u root password "$mysql_root_pass"
	#add to path
	! grep -q "${mysql_location}/bin" /etc/profile && echo "PATH=${mysql_location}/bin:$PATH" >> /etc/profile
	. /etc/profile
fi
[ "$php" != "do_not_install" ] && [ $php_mode == "with_fastcgi" ] && /etc/init.d/php-fpm start
if_in_array "${memcached_filename}" "$other_soft_install" && /etc/init.d/memcached start
if_in_array "${PureFTPd_filename}" "$other_soft_install" && /etc/init.d/pureftpd start
netstat -nxtlp
echo "depends_prefix=$depends_prefix" >> /tmp/ezhttp_info_do_not_del
\cp $cur_dir/ez /usr/bin/ez
chmod +x /usr/bin/ez
[ "$apache" == "${apache2_4_filename}" ] && sed -i 's/Allow from All/Require all granted/' /usr/bin/ez
#记录安装了哪个包
echo "stack=$stack" >> /tmp/ezhttp_info_do_not_del
exit
}

#最后确认
last_confirm(){
	sleep 1
	clear
	echo "#################### your choice overview ####################"
	echo
	echo "Package: ${stack}"
	echo
	[ "$stack" != "lamp" ] && echo "*****Nginx Setting*****"
	[ "$stack" != "lamp" ] && echo "Nginx: ${nginx}"
	[ "$nginx" != "do_not_install" ] && [ "$stack" != "lamp" ] && echo "Nginx Location: $nginx_location"
	[ "$nginx" != "do_not_install" ] && [ "$stack" != "lamp" ] && echo "Nginx Configure Parameter: ${nginx_configure_args}"
	echo
	[ "$stack" != "lnmp" ] && echo "*****Apache Setting*****"
	[ "$stack" != "lnmp" ] && echo "Apache: ${apache}"
	[ "$apache" != "do_not_install" ] && [ "$stack" != "lnmp" ] && echo "Apache Location: $apache_location"
	[ "$apache" != "do_not_install" ] && [ "$stack" != "lnmp" ] && echo "Apache Configure Parameter: ${apache_configure_args}"
	echo
	echo "*****MySQL Setting*****"
	echo "MySQL Server: $mysql"
	[ "$mysql" != "do_not_install" ] || [ "$mysql_location" != "" ] && echo "MySQL Location: $mysql_location"
	[ "$mysql" != "do_not_install" ] || [ "$mysql_data_location" != "" ] &&  echo "MySQL Data Location: $mysql_data_location"
	[ "$mysql" != "do_not_install" ] || [ "$mysql_root_pass" != "" ] && echo "MySQL Root Password: $mysql_root_pass"
	[ "$mysql" != "do_not_install" ] && echo "MySQL Configure Parameter: ${mysql_configure_args}"
	echo
	echo "*****PHP Setting*****"
	echo "PHP: $php"
	[ "$php" != "do_not_install" ] && echo "PHP Location: $php_location"
	[ "$php_modules_install" != "do_not_install" ] && echo "PHP Modules: ${php_modules_install}"
	[ "$php" != "do_not_install" ] && echo "PHP Configure Parameter: ${php_configure_args}"
	echo
	echo "*****Other Software Setting*****"
	echo "Other Software: ${other_soft_install}"
	if_in_array "${memcached_filename}" "$other_soft_install" && echo "memcached location: $memcached_location"
	if_in_array "${PureFTPd_filename}" "$other_soft_install" && echo "pureftpd location: $pureftpd_location"
	if_in_array "${phpMyAdmin_filename}" "$other_soft_install" && echo "phpmyadmin_location: $phpmyadmin_location"
	echo
	echo "##############################################################"
	echo
	#最终确认是否安装
	yes_or_no "Are you ready to configure your Linux [Y/n]: " "echo 'start to configure linux...'" "clear ; pre_setting"

	#检测端口或socket是否被占用
	echo "start to check if port is occupied..."
	check_port_socket_exist
}

#配置linux
deploy_linux(){
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
rootness
pre_setting
}