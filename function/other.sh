#提示是否使用上一次的设置
if_use_previous_setting(){
if [ -s "/root/previous_setting" ];then
	#是否使用上次设置安装
	yes_or_no "previous settings found,would you like using the previous settings from the file /root/previous_setting?[Y/n]" "pre_settings_modify=false;install_with_pre_settings" "pre_settings_modify=true;rm -f /root/previous_setting;lanmp_menu" y
else
	pre_settings_modify=true
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
	[[ "$PARMS" == "" ]] && last_confirm
	#记录设置
	$pre_settings_modify && record_setting
	#开始安装
	disable_selinux
	#安装工具
	install_tool

	[ "$nginx" != "do_not_install" ] && check_installed "install_nginx" "$nginx_location"
	[ "$mysql" != "do_not_install" ] && check_installed "install_mysqld" "$mysql_location"
	[ "$php" != "do_not_install" ] && check_installed "install_php" "$php_location"
	[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$phpConfig"
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
	[[ "$PARMS" == "" ]] && last_confirm
	#记录设置
	$pre_settings_modify && record_setting	
	#开始安装
	disable_selinux
	#安装工具
	install_tool

	[ "$apache" != "do_not_install" ] && check_installed "install_apache" "$apache_location"
	[ "$mysql" != "do_not_install" ] && check_installed "install_mysqld" "$mysql_location"
	[ "$php" != "do_not_install" ] && check_installed "install_php" "$php_location"
	[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$phpConfig"
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
	[[ "$PARMS" == "" ]] && last_confirm
	#记录设置
	$pre_settings_modify && record_setting	
	#开始安装
	disable_selinux
	#安装工具
	install_tool

	[ "$nginx" != "do_not_install" ] && check_installed "install_nginx" "$nginx_location"
	[ "$apache" != "do_not_install" ] && check_installed "install_apache" "$apache_location"
	[ "$mysql" != "do_not_install" ] && check_installed "install_mysqld" "$mysql_location"
	[ "$php" != "do_not_install" ] && check_installed "install_php" "$php_location"
	[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$phpConfig"
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
nginx_configure_args="${nginx_configure_args}"
nginx_modules_install="${nginx_modules_install}"
apache="$apache"
apache_location="$apache_location"
apache_configure_args='${apache_configure_args}'
mysql="$mysql"
mysql_location="$mysql_location"
mysql_data_location="$mysql_data_location"
mysql_root_pass="$mysql_root_pass"
mysql_port_number="$mysql_port_number"
mysql_configure_args='${mysql_configure_args}'
php="$php"
php_location="$php_location"
php_mode="$php_mode"
php_modules_install="${php_modules_install}"
php_source_location="${php_source_location}"
phpConfig="${phpConfig}"
php_configure_args='${php_configure_args}'
other_soft_install="${other_soft_install}"
memcached_location="${memcached_location}"
pureftpd_location="${pureftpd_location}"
user_manager_location="${user_manager_location}"
user_manager_pureftpd="${user_manager_pureftpd}"
pureftpd_database="${pureftpd_database}"
pureftpd_user="${pureftpd_user}"
pureftpd_user_pass="${pureftpd_user_pass}"
pureftpd_login_user="${pureftpd_login_user}"
pureftpd_login_pass="${pureftpd_login_pass}"
phpmyadmin_location="${phpmyadmin_location}"
redis_location="${redis_location}"
redisMaxMemory="${redisMaxMemory}"
mongodb_location="${mongodb_location}"
mongodb_data_location="${mongodb_data_location}"
phpRedisAdmin_location="${phpRedisAdmin_location}"
memadmin_location=${memadmin_location}
rockmongo_location=${rockmongo_location}
jdk7_location=${jdk7_location}
jdk8_location=${jdk8_location}
JAVA_HOME=${EZ_JAVA_HOME}
tomcat7_location=${tomcat7_location}
tomcat8_location=${tomcat8_location}
EOF
#自定义版本时增加变量
echo -e "$custom_info" >> /root/previous_setting
}


#安装前设置
pre_setting(){
#主菜单
while true
do
	echo -e "1) Installation of stack.\n2) Some Useful Tools.\n3) Upgrade Software\n4) Exit.\n"
	read -p "please select: " select
	case $select in
	1) echo "you select Installation of stack." ; if_use_previous_setting ; break;;
	2) echo "you select Some Useful Tools." ; tools_setting ; break;;
	3) echo "you select Upgrade Software." ; upgrade_software ; break;;
	4) echo "you select exit." ; exit 1;;
	*) echo "input error.";;
	esac
done
}

#完成后的一些配置
post_done(){
echo "start programs..."
#启动nginx
[ "$nginx" != "do_not_install" ] && [ "$stack" != "lamp" ] &&  /etc/init.d/nginx start
#启动apache
[ "$apache" != "do_not_install" ] && [ "$stack" != "lnmp" ] && /etc/init.d/httpd start
#启动mysql
if 	[ "$mysql" != "do_not_install" ] &&  [ "$mysql" != "libmysqlclient18" ];then
	#配置mysql
	service mysqld start
	if [ "$mysql" == "${mysql8_0_filename}" ];then
		${mysql_location}/bin/mysqladmin flush-privileges password 'root'
	else	
		${mysql_location}/bin/mysqladmin -u root password "$mysql_root_pass"
	fi	
	#add to path
	! grep -q "${mysql_location}/bin" /etc/profile && echo "PATH=${mysql_location}/bin:$PATH" >> /etc/profile
	. /etc/profile
fi

if [[ $user_manager_pureftpd == true ]]; then

#pureftpd web panel设置
${mysql_location}/bin/mysql -uroot -p${mysql_root_pass} <<EOF
DROP DATABASE IF EXISTS ${pureftpd_database};
CREATE DATABASE ${pureftpd_database};

grant all privileges on ${pureftpd_database}.* to '${pureftpd_user}'@'localhost' identified by '${pureftpd_user_pass}';
grant all privileges on ${pureftpd_database}.* to '${pureftpd_user}'@'127.0.0.1' identified by '${pureftpd_user_pass}';
FLUSH PRIVILEGES;

USE ${pureftpd_database};
CREATE TABLE admin (
  Username varchar(35) NOT NULL default '',
  Password char(32) binary NOT NULL default '',
  PRIMARY KEY  (Username)
);

INSERT INTO admin VALUES ('${pureftpd_login_user}',MD5('${pureftpd_login_pass}'));
CREATE TABLE users (
  User varchar(16) NOT NULL default '',
  Password varchar(32) binary NOT NULL default '',
  Uid int(11) NOT NULL default '14',
  Gid int(11) NOT NULL default '5',
  Dir varchar(128) NOT NULL default '',
  QuotaFiles int(10) NOT NULL default '500',
  QuotaSize int(10) NOT NULL default '30',
  ULBandwidth int(10) NOT NULL default '80',
  DLBandwidth int(10) NOT NULL default '80',
  Ipaddress varchar(15) NOT NULL default '*',
  Comment tinytext,
  Status enum('0','1') NOT NULL default '1',
  ULRatio smallint(5) NOT NULL default '1',
  DLRatio smallint(5) NOT NULL default '1',
  PRIMARY KEY  (User),
  UNIQUE KEY User (User)
);

EOF

fi

#启动php
[ "$php" != "do_not_install" ] && [ $php_mode == "with_fastcgi" ] && /etc/init.d/php-fpm start
#启动各软件
if_in_array "${memcached_filename}" "$other_soft_install" && /etc/init.d/memcached start
if_in_array "${PureFTPd_filename}" "$other_soft_install" && /etc/init.d/pureftpd start
if_in_array "${redis_filename}" "$other_soft_install" && /etc/init.d/redis start
if_in_array "${mongodb_filename}" "$other_soft_install" && /etc/init.d/mongod start

#安装模块时重启php
if [ "$php" == "do_not_install" ] && [ "$php_modules_install" != "do_not_install" ];then
	if [ "$stack" == "lnmp" ];then
		service php-fpm restart
	else
		/etc/init.d/httpd restart
	fi
fi

sleep 5
ss -nlpxt
echo "depends_prefix=$depends_prefix" >> /etc/ezhttp_info_do_not_del
\cp $cur_dir/ez /usr/bin/ez
chmod +x /usr/bin/ez
[ "$apache" == "${apache2_4_filename}" ] && sed -i 's/Allow from All/Require all granted/' /usr/bin/ez
#记录安装了哪个包
echo "stack=$stack" >> /etc/ezhttp_info_do_not_del
echo "Installation is finished! if it do not return to the terminal,please press ctrl+c."
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
	[ "$nginx" != "do_not_install" ] && [ "$stack" != "lamp" ] && echo "Nginx Modules: ${nginx_modules_install}"
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
	[ "$mysql" != "do_not_install" ] || [ "$mysql_data_location" != "" ] &&  echo "MySQL Port Number: ${mysql_port_number}"
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
	[[ $user_manager_pureftpd == true ]] && echo "pureftpd web panel location: $user_manager_location" && \
	echo "pureftpd db: $pureftpd_database" && echo "pureftpd db user: ${pureftpd_user}" && \
	echo "pureftpd db user password: $pureftpd_user_pass" && echo "pureftpd panel login user: ${pureftpd_login_user}" && echo "pureftpd panel login user password: ${pureftpd_login_pass}"
	if_in_array "${phpMyAdmin_filename}" "$other_soft_install" && echo "phpmyadmin_location: $phpmyadmin_location"
	if_in_array "${redis_filename}" "$other_soft_install" && echo "redis_location: $redis_location"
	if_in_array "${mongodb_filename}" "$other_soft_install" && echo "mongodb_location: $mongodb_location"
	if_in_array "${phpRedisAdmin_filename}" "$other_soft_install" && echo "phpRedisAdmin_location: ${phpRedisAdmin_location}"
	if_in_array "${memadmin_filename}" "$other_soft_install" && echo "memadmin_location: ${memadmin_location}"
	if_in_array "${rockmongo_filename}" "$other_soft_install" && echo "rockmongo_location: ${rockmongo_location}"
	if_in_array "${jdk7_filename}" "$other_soft_install" && echo "jdk7_location: ${jdk7_location}"
	if_in_array "${jdk8_filename}" "$other_soft_install" && echo "jdk8_location: ${jdk8_location}"
	if_in_array "${tomcat7_filename}" "$other_soft_install" && echo "tomcat7_location: ${tomcat7_location}" && echo "JAVA_HOME: ${EZ_JAVA_HOME}"
	if_in_array "${tomcat8_filename}" "$other_soft_install" && echo "tomcat8_location: ${tomcat8_location}" && echo "JAVA_HOME: ${EZ_JAVA_HOME}"
	echo
	echo "##############################################################"
	echo
	#最终确认是否安装
	yes_or_no "Are you ready to configure your Linux?[Y/n]" "echo 'start to configure linux...'" "clear ; pre_setting" y

	#检测端口或socket是否被占用
	echo "start to check if port is occupied..."
	check_port_socket_exist

	# 为防止安装失败,安装前同步下时间
	sync_time
}

#检测端口或socket是否被占用
check_port_socket_exist(){
	if [[ $stack == "lnmp" ]];then
		if [[ $nginx != "do_not_install" ]]; then
			kill_pid "port" "80"
		fi

		if [[ $php != "do_not_install" ]]; then
			kill_pid "port" "9000"
		fi	

		if [[ $mysql != "do_not_install" ]]; then
			kill_pid "port" "${mysql_port_number}"
		fi		

	elif [[ $stack == "lamp" ]]; then
		if [[ $apache != "do_not_install" ]]; then
			kill_pid "port" "80"
		fi
			
		if [[ $mysql != "do_not_install" ]]; then
			kill_pid "port" "${mysql_port_number}"
		fi		

	elif [[ $stack == "lnamp" ]]; then
		if [[ $nginx != "do_not_install" ]]; then
			kill_pid "port" "80"
		fi

		if [[ $apache != "do_not_install" ]]; then
			kill_pid "port" "88"
		fi
			
		if [[ $mysql != "do_not_install" ]]; then
			kill_pid "port" "${mysql_port_number}"
		fi	
	fi	

	if_in_array "${memcached_filename}" "$other_soft_install" && kill_pid "port" "11211"
	if_in_array "${PureFTPd_filename}" "$other_soft_install" && kill_pid "port" "21"
	if_in_array "${redis_filename}" "$other_soft_install" && kill_pid "port" "6379"		
	if_in_array "${mongodb_filename}" "$other_soft_install" && kill_pid "port" "27017"	
}