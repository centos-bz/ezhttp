#安装其它软件前设置
othersoft_preinstall_settings(){
#显示菜单
display_menu_multi other_soft
#配置安装路径
if [ "$other_soft_install" != "do_not_install" ];then

	#memcached安装路径
	if if_in_array "${memcached_filename}" "$other_soft_install";then
		read -p "input $memcached_filename location(default:/usr/local/memcached): " memcached_location
		memcached_location=${memcached_location:=/usr/local/memcached}
		memcached_location=`filter_location "$memcached_location"`
		echo "memcached location: $memcached_location"
	fi	

	#pureftpd安装路径
	if if_in_array "${PureFTPd_filename}" "$other_soft_install";then
		read -p "input $PureFTPd_filename location(default:/usr/local/pureftpd): " pureftpd_location
		pureftpd_location=${pureftpd_location:=/usr/local/pureftpd}
		pureftpd_location=`filter_location "$pureftpd_location"`
		echo "pureftpd location: $pureftpd_location"
		yes_or_no "Would you like to install web user manager for pureftpd [N/y]: " "user_manager_pureftpd=true" "echo 'you select not install web manager'"
		if [[ $yn == "y" ]]; then
			if [[ $mysql_root_pass == "" ]]; then
				read -p "please input mysql root password: " mysql_root_pass
				read -p "please input mysql install location(default:/usr/local/mysql): " mysql_location
				mysql_location=${mysql_location:=/usr/local/mysql}
				mysql_location=`filter_location "$mysql_location"`
			fi

			#输入use_manager_pureftpd安装路径
			read -p "please input pureftpd user web manager install location(default:/home/wwwroot/ftp/): " user_manager_location
			user_manager_location=${user_manager_location:=/home/wwwroot/ftp/}
			user_manager_location=`filter_location "$user_manager_location"`

			#输入pureftpd数据库及用户信息
			read -p "please input mysql database name for storing pureftpd user data(default:pureftpd): " pureftpd_database
			pureftpd_database=${pureftpd_database:=pureftpd}
			read -p "please input the user for database $pureftpd_database(default:ftpuser)" pureftpd_user
			pureftpd_user=${pureftpd_user:=ftpuser}
			read -p "please input the password for mysql user $pureftpd_user(default:generate by random.): " pureftpd_user_pass
			[[ $pureftpd_user_pass == "" ]] && echo "generate password.." &&  pureftpd_user_pass=`generate_password` && echo "password is $pureftpd_user_pass"

			#输入user_manger_pureftpd用户和密码
			read -p "please input the user for login pureftpd web manager(default:admin): " pureftpd_login_user
			pureftpd_login_user=${pureftpd_login_user:=admin}
			read -p "please input the password for user $pureftpd_login_user(default:generate by random.): " pureftpd_login_pass
			[[ $pureftpd_login_pass == "" ]] && echo "generate password.." &&  pureftpd_login_pass=`generate_password` && echo "password is $pureftpd_login_pass"
		fi
	fi	

	#phpmyadmin安装路径
	if if_in_array "${phpMyAdmin_filename}" "$other_soft_install";then
		default_location="/home/wwwroot/phpmyadmin"
		read -p "input $phpMyAdmin_filename location(default:$default_location): " phpmyadmin_location
		phpmyadmin_location=${phpmyadmin_location:=$default_location}
		phpmyadmin_location=`filter_location "$phpmyadmin_location"`
		echo "phpmyadmin location: $phpmyadmin_location"
	fi

	#设置redis安装路径及最大内存使用
	if if_in_array "${redis_filename}" "$other_soft_install";then
		default_location="/usr/local/redis"
		read -p "input $redis_filename location(default:$default_location): " redis_location
		redis_location=${redis_location:=$default_location}
		redis_location=`filter_location "$redis_location"`
		echo "redis location: $redis_location"
		while true; do
			read -p "please input the max memory allowed for redis(ie.128M,512m,2G,4g): " redisMaxMemory
			if echo "$redisMaxMemory" | grep -q -E "^[0-9]+[mMgG]$";then
				break
			else
				echo "input errors,please input ie.128M,512m,2G,4g"
			fi
		done

		#转换成Byte
		if echo "$redisMaxMemory" | grep "[mM]$";then
			redisMaxMemory=`echo $redisMaxMemory | grep -o -E "[0-9]+"`
			((redisMaxMemory=$redisMaxMemory*1024*1024))
		elif echo "$redisMaxMemory" | grep "[gG]$"; then
			redisMaxMemory=`echo $redisMaxMemory | grep -o -E "[0-9]+"`
			((redisMaxMemory=$redisMaxMemory*1024*1024*1024))
		fi
	fi

	#mongodb安装路径及db路径
	if if_in_array "${mongodb_filename}" "$other_soft_install";then
		default_location="/usr/local/mongodb"
		read -p "input $mongodb_filename location(default:$default_location): " mongodb_location
		mongodb_location=${mongodb_location:=$default_location}
		mongodb_location=`filter_location "$mongodb_location"`
		echo "mongodb location: $mongodb_location"

		default_data_location="$mongodb_location/data/"
		read -p "input $mongodb_filename data location(default:$default_data_location): " mongodb_data_location
		mongodb_data_location=${mongodb_data_location:=$default_data_location}
		mongodb_data_location=`filter_location "$mongodb_data_location"`
		echo "mongodb data location: $mongodb_data_location"		
	fi

	#phpRedisAdmin安装路径
	if if_in_array "${phpRedisAdmin_filename}" "$other_soft_install";then
		default_location="/home/wwwroot/redisadmin"
		read -p "input $phpRedisAdmin_filename location(default:$default_location): " phpRedisAdmin_location
		phpRedisAdmin_location=${phpRedisAdmin_location:=$default_location}
		phpRedisAdmin_location=`filter_location "$phpRedisAdmin_location"`
		echo "phpRedisAdmin location: $phpRedisAdmin_location"
	fi

	#memadmin安装路径
	if if_in_array "${memadmin_filename}" "$other_soft_install";then
		default_location="/home/wwwroot/memadmin"
		read -p "input $memadmin_filename location(default:$default_location): " memadmin_location
		memadmin_location=${memadmin_location:=$default_location}
		memadmin_location=`filter_location "$memadmin_location"`
		echo "memadmin location: $memadmin_location"
	fi

	#rockmongo安装路径
	if if_in_array "${rockmongo_filename}" "$other_soft_install";then
		default_location="/home/wwwroot/rockmongo"
		read -p "input $rockmongo_filename location(default:$default_location): " rockmongo_location
		rockmongo_location=${rockmongo_location:=$default_location}
		rockmongo_location=`filter_location "$rockmongo_location"`
		echo "rockmongo location: $rockmongo_location"
	fi	

fi
}

#安装其它软件
install_other_soft(){
if_in_array "${memcached_filename}" "$other_soft_install" && check_installed_ask "install_Memcached" "${memcached_location}"
if_in_array "${PureFTPd_filename}" "$other_soft_install" && check_installed_ask "install_PureFTPd" "${pureftpd_location}"
if_in_array "${phpMyAdmin_filename}" "$other_soft_install" && check_installed_ask "install_phpmyadmin" "${phpmyadmin_location}"
if_in_array "${redis_filename}" "$other_soft_install" && check_installed_ask "install_redis" "${redis_location}"
if_in_array "${mongodb_filename}" "$other_soft_install" && check_installed_ask "install_mongodb" "${mongodb_location}"
if_in_array "${phpRedisAdmin_filename}" "$other_soft_install" && check_installed_ask "install_redisadmin" "${phpRedisAdmin_location}"
if_in_array "${memadmin_filename}" "$other_soft_install" && check_installed_ask "install_memadmin" "${memadmin_location}"
if_in_array "${rockmongo_filename}" "$other_soft_install" && check_installed_ask "install_rockmongo" "${rockmongo_location}"
}

#安装memcached
install_Memcached(){
groupadd memcache
useradd -M -s /bin/false -g memcache memcache
#安装依赖
if check_sys packageManager apt;then
	apt-get -y install libevent-dev
elif check_sys packageManager yum;then
	yum -y install libevent-devel
else
	check_installed "install_libevent" "${depends_prefix}/${libevent_filename}"
fi		

download_file "${memcached_other_link}" "${memcached_official_link}" "${memcached_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${memcached_filename}.tar.gz
cd ${memcached_filename}
make clean
if check_sys packageSupport;then
	other_option=""
else
	other_option="--with-libevent=${depends_prefix}/${libevent_filename}"
fi
error_detect "./configure --prefix=$memcached_location $other_option"
error_detect "parallel_make"
error_detect "make install"
rm -f /etc/init.d/memcached
cp $cur_dir/conf/memcached-init /etc/init.d/memcached
chmod +x /etc/init.d/memcached
sed -i "s#^memcached_location=.*#memcached_location=$memcached_location#" /etc/init.d/memcached
mkdir -p /var/lock/subsys/
echo "memcached_location=$memcached_location" >> /etc/ezhttp_info_do_not_del
boot_start memcached
}

#安装phpMyAdmin
install_phpmyadmin(){
download_file "${phpMyAdmin_other_link}" "${phpMyAdmin_official_link}" "${phpMyAdmin_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${phpMyAdmin_filename}.tar.gz
mkdir -p ${phpmyadmin_location}
\cp -a ${phpMyAdmin_filename}/* ${phpmyadmin_location}
#禁用phpmyadmin自动在线检测版本功能，因为在国内有时无法访问检测版本的链接，会导致超时，影响phpmyadmin操作。
sed -i '1aexit;' $phpmyadmin_location/version_check.php
}

#安装PureFTPd
install_PureFTPd(){
download_file "${PureFTPd_other_link}" "${PureFTPd_official_link}" "${PureFTPd_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${PureFTPd_filename}.tar.gz
cd ${PureFTPd_filename}
make clean
[[ $user_manager_pureftpd == true ]] && other_option="--with-mysql=${mysql_location} --with-altlog --with-cookie --with-throttling --with-ratios --with-quotas --with-language=simplified-chinese" || other_option=""
error_detect "./configure --prefix=$pureftpd_location $other_option"
error_detect "parallel_make"
error_detect "make install"
mkdir -p $pureftpd_location/etc
cp -f configuration-file/pure-config.pl $pureftpd_location/bin/pure-config.pl
cp -f configuration-file/pure-ftpd.conf $pureftpd_location/etc
rm -f /etc/init.d/pureftpd
cp -f $cur_dir/conf/init.d.pureftpd /etc/init.d/pureftpd
chmod +x /etc/init.d/pureftpd
sed -i "s#^pureftpd_location=.*#pureftpd_location=$pureftpd_location#" /etc/init.d/pureftpd
sed -i "s#\${exec_prefix}#$pureftpd_location#" $pureftpd_location/bin/pure-config.pl
chmod +x ${pureftpd_location}/bin/pure-config.pl
echo "pureftpd_location=$pureftpd_location" >> /etc/ezhttp_info_do_not_del
boot_start pureftpd

#如果选择安装ftp面板
if [[ $user_manager_pureftpd == true ]]; then
	#修改pure-ftpd.conf
	if ! grep -q "^MySQLConfigFile" $pureftpd_location/etc/pure-ftpd.conf;then
		sed -i "s@# MySQLConfigFile.*@MySQLConfigFile    $pureftpd_location/etc/pureftpd-mysql.conf@" $pureftpd_location/etc/pure-ftpd.conf
		if ! grep -q "^MySQLConfigFile" $pureftpd_location/etc/pure-ftpd.conf;then
			echo "MySQLConfigFile    $pureftpd_location/etc/pureftpd-mysql.conf" >> $pureftpd_location/etc/pure-ftpd.conf
		fi	
	fi

	#增加pureftpd-mysql.conf
	cat > $pureftpd_location/etc/pureftpd-mysql.conf <<EOF
	MYSQLSocket     /tmp/mysql.sock
	MYSQLPort       3306
	MYSQLUser       $pureftpd_user
	MYSQLPassword   $pureftpd_user_pass
	MYSQLDatabase   $pureftpd_database
	MYSQLCrypt 	md5


	MYSQLGetPW      SELECT Password FROM users WHERE User="\L" AND Status="1" AND (Ipaddress = "*" OR Ipaddress LIKE "\R")
	MYSQLGetUID     SELECT Uid FROM users WHERE User="\L" AND Status="1" AND (Ipaddress = "*" OR Ipaddress LIKE "\R")
	MYSQLGetGID     SELECT Gid FROM users WHERE User="\L" AND Status="1" AND (Ipaddress = "*" OR Ipaddress LIKE "\R")
	MYSQLGetDir     SELECT Dir FROM users WHERE User="\L" AND Status="1" AND (Ipaddress = "*" OR Ipaddress LIKE "\R")
	MySQLGetRatioUL SELECT ULRatio FROM users WHERE User="\L"
	MySQLGetRatioDL SELECT DLRatio FROM users WHERE User="\L"
	MySQLGetBandwidthUL SELECT ULBandwidth FROM users WHERE User="\L" AND Status="1" AND (Ipaddress = "*" OR Ipaddress LIKE "\R")
	MySQLGetBandwidthDL SELECT DLBandwidth FROM users WHERE User="\L" AND Status="1" AND (Ipaddress = "*" OR Ipaddress LIKE "\R")

EOF

	#安装ftp面板
	download_file "$user_manager_pureftpd_other_link" "$user_manager_pureftpd_official_link" "${user_manager_pureftpd_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${user_manager_pureftpd_filename}.tar.gz
	mkdir -p ${user_manager_location}
	\cp -a ftp/* ${user_manager_location}
	sed -i 's/$LANG = "English";/$LANG = "Chinese";/' ${user_manager_location}/config.php
	sed -i "s/$DBLogin = \"ftp\";/$DBLogin = \"$pureftpd_user\";/" ${user_manager_location}/config.php
	sed -i "s/$DBPassword = \"tmppasswd\";/$DBPassword = \"$pureftpd_user_pass\";/" ${user_manager_location}/config.php
	sed -i "s/$DBDatabase = \"ftpusers\";/$DBDatabase = \"$pureftpd_database\";/" ${user_manager_location}/config.php

	#记录安装信息
	echo "user_manager_pureftpd=true" >> /etc/ezhttp_info_do_not_del
else
	echo "user_manager_pureftpd=false" >> /etc/ezhttp_info_do_not_del
fi	
}

#安装redis
install_redis(){
groupadd redis	
useradd -M -s /bin/false -g redis redis
download_file "${redis_other_link}" "${redis_official_link}" "${redis_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${redis_filename}.tar.gz
cd ${redis_filename}
make clean
error_detect "parallel_make"
mkdir -p ${redis_location}/etc/ ${redis_location}/logs/ ${redis_location}/db/ ${redis_location}/bin/
\cp redis.conf ${redis_location}/etc/
#更改配置文件
sed -i 's/^daemonize.*/daemonize yes/' ${redis_location}/etc/redis.conf
sed -i "s#^pidfile.*#pidfile ${redis_location}/logs/redis.pid#" ${redis_location}/etc/redis.conf
sed -i 's/^tcp-keepalive.*/tcp-keepalive 60/' ${redis_location}/etc/redis.conf
sed -i "s#^logfile.*#logfile ${redis_location}/logs/redis.log#" ${redis_location}/etc/redis.conf
sed -i 's/^stop-writes-on-bgsave-error.*/stop-writes-on-bgsave-error no/' ${redis_location}/etc/redis.conf
sed -i "s#^dir.*#dir ${redis_location}/db/#" ${redis_location}/etc/redis.conf
sed -i "s/^# maxmemory .*/maxmemory $redisMaxMemory/" ${redis_location}/etc/redis.conf
sed -i "s/^# maxmemory-policy.*/maxmemory-policy allkeys-lru/" ${redis_location}/etc/redis.conf


sed -i 's/^appendonly.*/appendonly yes/' ${redis_location}/etc/redis.conf

\cp src/redis-server src/redis-cli src/redis-benchmark src/redis-check-aof src/redis-check-dump ${redis_location}/bin/

\cp utils/redis_init_script /etc/init.d/redis 
sed -i "s#^EXEC=.*#EXEC=${redis_location}/bin/redis-server#" /etc/init.d/redis 
sed -i "s#^CLIEXEC=.*#CLIEXEC=${redis_location}/bin/redis-cli#" /etc/init.d/redis 
sed -i "s#^PIDFILE=.*#PIDFILE=${redis_location}/logs/redis.pid#" /etc/init.d/redis 
sed -i "s#^CONF=.*#CONF=${redis_location}/etc/redis.conf#" /etc/init.d/redis 
sed -i '2 a\# chkconfig:   - 85 15' /etc/init.d/redis
sed -i 's#$EXEC $CONF#su -s /bin/bash -c "$EXEC $CONF" redis \&#' /etc/init.d/redis

chown -R redis ${redis_location} 
chmod +x /etc/init.d/redis
boot_start redis

! grep "vm.overcommit_memory = 1"  /etc/sysctl.conf && echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
sysctl -p
}

#安装mongo
install_mongodb(){
groupadd mongod	
useradd -M -s /bin/false -g mongod mongod
download_file "${mongodb_other_link}" "${mongodb_official_link}" "${mongodb_filename}.tgz"
cd $cur_dir/soft/
tar xzvf ${mongodb_filename}.tgz
mkdir -p  ${mongodb_location}/etc/ ${mongodb_location}/logs/ ${mongodb_data_location}
cp -a $mongodb_filename/bin/ $mongodb_location

cat > ${mongodb_location}/etc/mongod.conf <<EOF
# mongod.conf

#where to log
logpath=${mongodb_location}/logs/mongod.log

logappend=true

# fork and run in background
fork = true

port = 27017

# Set this value to designate a directory for the mongod instance to store its data
dbpath=${mongodb_data_location}

# Set to true to modify the storage pattern of the data directory to store each database’s files in a distinct folder. 
# This option will create directories within the dbpath named for each database.
directoryperdb=true

# location of pidfile
pidfilepath = ${mongodb_location}/logs/mongod.pid

# Disables write-ahead journaling
# nojournal = true
journal = true

# Modify this value to changes the level of database profiling
# 0	Off. No profiling.
# 1	On. Only includes slow operations.
# 2	On. Includes all operations.
profile = 0

# Sets the threshold for mongod to consider a query "slow" for the database profiler
slowms = 100



# Turn on/off security.  Off is currently the default
#noauth = true

# Verbose logging output.
#verbose = true

# Inspect all client data for validity on receipt (useful for
# developing drivers)
objcheck = true

# Enable db quota management
#quota = true

# Set oplogging level where n is
#   0=off (default)
#   1=W
#   2=R
#   3=both
#   7=W+some reads
diaglog = 0

# Ignore query hints
#nohints = true

# Disable the HTTP interface (Defaults to localhost:27018).
#nohttpinterface = true

# Turns off server-side scripting.  This will result in greatly limited
# functionality
#noscripting = true

# Turns off table scans.  Any query that would do a table scan fails.
#notablescan = true

# Disable data file preallocation.
#noprealloc = true

# Specify .ns file size for new databases.
# nssize = <size>

# Accout token for Mongo monitoring server.
#mms-token = <token>

# Server name for Mongo monitoring server.
#mms-name = <server-name>

# Ping interval for Mongo monitoring server.
#mms-interval = <seconds>

# Replication Options

# in replicated mongo databases, specify here whether this is a slave or master
#slave = true
#source = master.example.com
# Slave only: specify a single database to replicate
#only = master.example.com
# or
#master = true
#source = slave.example.com

EOF

cat > /etc/init.d/mongod <<EOF
#!/bin/bash

# mongod - Startup script for mongod

# chkconfig: 35 85 15

CONF=${mongodb_location}/etc/mongod.conf
PID=${mongodb_location}/logs/mongod.pid
do_start () {
echo  "Starting mongo with-> /usr/bin/mongod –config \$CONF"
su -s /bin/bash -c "${mongodb_location}/bin/mongod --config \$CONF" mongod &
}

do_stop () {
echo "checking if mongo is running"
if [ -z "\$PID" ];
    then
    echo "mongod isn't running, no need to stop"
    exit
fi
echo "Stopping mongo with-> /bin/kill -2 \`cat \$PID\`"
/bin/kill -2 \`cat \$PID\`

}

case "\$1" in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  *)
    echo "Usage: \$0 start|stop" >&2
    exit 3
    ;;
esac

EOF

chown -R mongod ${mongodb_location}
chown -R mongod ${mongodb_data_location}
chmod +x /etc/init.d/mongod
boot_start mongod
}


#安装phpRedisAdmin
install_redisadmin(){
download_file "${phpRedisAdmin_other_link}" "${phpRedisAdmin_official_link}" "${phpRedisAdmin_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${phpRedisAdmin_filename}.tar.gz
mkdir -p ${phpRedisAdmin_location}
\cp -a ${phpRedisAdmin_filename}/* ${phpRedisAdmin_location}

#Predis
download_file "${Predis_other_link}" "${Predis_official_link}" "${Predis_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${Predis_filename}.tar.gz
mkdir -p ${phpRedisAdmin_location}/vendor/
\cp -a ${Predis_filename}/* ${phpRedisAdmin_location}/vendor/

}

#安装memadmin
install_memadmin(){
download_file "${memadmin_other_link}" "${memadmin_official_link}" "${memadmin_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${memadmin_filename}.tar.gz
mkdir -p ${memadmin_location}
\cp -a ${memadmin_filename}/* ${memadmin_location}
}

#安装rockmongo
install_rockmongo(){
download_file "${rockmongo_other_link}" "${rockmongo_official_link}" "${rockmongo_filename}.zip"
cd $cur_dir/soft/
rm -rf rockmongo-fix-auth
unzip ${rockmongo_filename}.zip
mkdir -p ${rockmongo_location}
\cp -a rockmongo-fix-auth/* ${rockmongo_location}

}