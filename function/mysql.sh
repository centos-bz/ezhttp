#mysql安装前设置
mysql_preinstall_settings(){
display_menu mysql last
#自定义版本支持
if [ "$mysql" == "custom_version" ];then
	while true
	do
		read -p "input version.(ie.mysql-5.1.71 mysql-5.5.32 mysql-5.6.12 mysql-5.7.9 mysql-8.0.11): " version
		#判断版本号是否有效
		if echo "$version" | grep -q -E '^mysql-5\.1\.[0-9]+$';then
			mysql5_1_filename=$version
			mysql=$version
			set_dl $version "http://cdn.mysql.com/Downloads/MySQL-5.1/${mysql}.tar.gz"
			custom_info="$custom_info\nmysql5_1_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
			break
		elif echo "$version" | grep -q -E '^mysql-5\.5\.[0-9]+$';then
			mysql5_5_filename=$version
			mysql=$version
			set_dl $version "http://cdn.mysql.com/Downloads/MySQL-5.5/${mysql}.tar.gz"
			custom_info="$custom_info\nmysql5_5_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
			break
		elif echo "$version" | grep -q -E '^mysql-5\.6\.[0-9]+$';then
			mysql5_6_filename=$version
			mysql=$version
			set_dl $version "http://cdn.mysql.com/Downloads/MySQL-5.6/${mysql}.tar.gz"
			custom_info="$custom_info\nmysql5_6_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
			break
		elif echo "$version" | grep -q -E '^mysql-5\.7\.[0-9]+$';then
			mysql5_7_filename=$version
			mysql=$version
			set_dl $version "http://cdn.mysql.com/Downloads/MySQL-5.7/${mysql}.tar.gz"
			custom_info="$custom_info\nmysql5_7_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
			break		
		elif echo "$version" | grep -q -E '^mysql-8\.0\.[0-9]+$';then
			mysql8_0_filename=$version
			mysql=$version
			set_dl $version "http://cdn.mysql.com/Downloads/MySQL-8.0/${mysql}.tar.gz"
			custom_info="$custom_info\nmysql8_0_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
			break									
		else
			echo "version invalid,please reinput."
		fi
	done	
fi	

if [ "$mysql" != "do_not_install" ];then
	while true; do
		#mysql安装路径
		read -p "$mysql install location(default:/usr/local/mysql,leave blank for default): " mysql_location
		mysql_location=${mysql_location:="/usr/local/mysql"}
		mysql_location=`filter_location "$mysql_location"`
		echo "$mysql install location: $mysql_location"
		if [[ -e $mysql_location ]]; then
			yes_or_no "the location $mysql_location found,maybe mysql had been installed.skip mysql installation?[Y/n]" "mysql=do_not_install" "" y
			if [[ "$yn" == "n" ]]; then
				continue
			else
				break
			fi	
		else
			break
		fi	
	done

	if [ "$mysql" != "do_not_install" ];then
		#当只编译client时，不必输入data和密码
		if [ "$mysql" != "libmysqlclient18" ];then
			#mysql data路径
			read -p "mysql data location(default:${mysql_location}/data,leave blank for default): " mysql_data_location
			mysql_data_location=${mysql_data_location:=$mysql_location/data}
			mysql_data_location=`filter_location "$mysql_data_location"`
			echo "$mysql data location: $mysql_data_location"

			#mysql端口设置
			while true;do
				read -p "mysql port number(default:3306,leave blank for default): " mysql_port_number
				mysql_port_number=${mysql_port_number:=3306}
				if verify_port "$mysql_port_number";then
					echo "mysql port number: $mysql_port_number"
					break
				else
					echo "port number $mysql_port_number is invalid,please reinput."
				fi	
			done	

			#mysql密码设置
			read -p "mysql server root password (default:root,leave blank for default): " mysql_root_pass
			mysql_root_pass=${mysql_root_pass:=root}
			echo "$mysql root password: $mysql_root_pass"

			#定义mysql编译参数
			if [ "$mysql" == "${mysql5_1_filename}" ];then
				if check_sys packageSupport;then
					other_option=""
				else
					other_option="--with-named-curses-libs=${depends_prefix}/${ncurses_filename2}/lib/libncurses.a"
				fi			
				mysql_configure_args="--prefix=${mysql_location} --sysconfdir=${mysql_location}/etc --with-unix-socket-path=${mysql_data_location}/mysql.sock --with-charset=utf8 --with-collation=utf8_general_ci --with-extra-charsets=complex --with-plugins=max --with-mysqld-ldflags=-all-static --enable-assembler $other_option"
			elif [ "$mysql" == "${mysql5_5_filename}" ] || [ "$mysql" == "libmysqlclient18" ];then
				if check_sys packageSupport;then
					other_option=""
				else
					other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
				fi
				mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 $other_option"
			elif [ "$mysql" == "${mysql5_6_filename}" ];then
				if check_sys packageSupport;then
					other_option=""
				else
					other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
				fi
				mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DENABLED_LOCAL_INFILE=1 $other_option"
			elif [ "$mysql" == "${mysql5_7_filename}" ];then
				if check_sys packageSupport;then
					other_option=""
				else
					other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
				fi
				mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DWITH_BOOST=$cur_dir/soft/${boost_1_59_filename}  -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 $other_option"
			elif [ "$mysql" == "${mysql8_0_filename}" ];then
				if check_sys packageSupport;then
					other_option=""
				else
					other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
				fi
				mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DWITH_BOOST=$cur_dir/soft/${boost_1_66_filename}  -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 $other_option"

			fi

			#提示是否更改编译参数
			echo -e "the $mysql configure parameter is:\n${mysql_configure_args}\n\n"
			yes_or_no "Would you like to change it?[N/y]" "read -p 'please input your new mysql configure parameter: ' mysql_configure_args" "echo 'you select no,configure parameter will not be changed.'" n
			if [[ "$yn" == "y" ]];then
				while true; do
					#检查编译参数是否为空
					if [ "$mysql_configure_args" == "" ];then
						echo "input error.mysql configure parameter can not be empty,please reinput."
						read -p 'please input your new mysql configure parameter: ' mysql_configure_args
						continue
					fi

					#检查是否设置prefix
					mysql_location=$(echo "$mysql_configure_args" | sed -r -n 's/.*DCMAKE_INSTALL_PREFIX=([^ ]*).*/\1/p')
					if [[ "$mysql_location" == "" ]]; then
						echo "input error.mysql configure parameter prefix can not be empty,please reinput."
						read -p 'please input your new mysql configure parameter: ' mysql_configure_args
						continue
					fi

					if [[ -e $mysql_location ]]; then
						yes_or_no "the location $mysql_location found,maybe mysql had been installed.skip mysql installation?[Y/n]" "mysql=do_not_install" "" y
						if [[ "$yn" == "n" ]]; then
							read -p 'please input your new mysql configure parameter: ' mysql_configure_args
							continue
						else
							break
						fi
					fi

					break
				done
				 [[ "$mysql" != "do_not_install" ]] && echo -e "\nyour new mysql configure parameter is : ${mysql_configure_args}\n"
			fi
		else
			if check_sys packageSupport;then
				other_option=""
			else
				other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/ -DWITH_SSL=${depends_prefix}/${openssl_filename}"
			fi
			mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DWITH_BOOST=$cur_dir/soft/${boost_1_59_filename} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1  $other_option"		
		fi
	fi	
fi	
}

#安装mysql server
install_mysqld(){
	if [ "$mysql" == "${mysql5_1_filename}" ];then

		#安装依赖
		if check_sys packageManager apt;then
			apt-get -y install libncurses5-dev
		elif check_sys packageManager yum;then
			yum -y install ncurses-devel
		else
			check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
		fi	

		download_file  "${mysql5_1_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${mysql5_1_filename}.tar.gz
		cd ${mysql5_1_filename}
		make clean
		error_detect "./configure ${mysql_configure_args}"
		error_detect "parallel_make"
		error_detect "make install"
		config_mysql 5.1

	elif [ "$mysql" == "${mysql5_5_filename}" ] || [ "$mysql" == "libmysqlclient18" ];then
		#安装依赖
		if check_sys packageManager apt;then
			apt-get -y install libncurses5-dev cmake m4 bison
		elif check_sys packageManager yum;then
			yum -y install ncurses-devel cmake m4 bison
		else
			check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
			check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
			check_installed "install_m4" "${depends_prefix}/${m4_filename}"
			check_installed "install_bison" "${depends_prefix}/${bison_filename}"
		fi		

		download_file  "${mysql5_5_filename}.tar.gz"
		cd $cur_dir/soft/
		rm -rf ${mysql5_5_filename}
		tar xzvf ${mysql5_5_filename}.tar.gz
		cd ${mysql5_5_filename}
		mkdir build
		cd build
		error_detect "cmake ${mysql_configure_args} .."
		#为只编译client作处理
		if [ "$mysql" == "libmysqlclient18" ];then
			error_detect "make mysqlclient libmysql"
			mkdir -p ${mysql_location}/lib ${mysql_location}/bin
			\cp  -a libmysql/libmysqlclient* ${mysql_location}/lib
			\cp  -a scripts/mysql_config ${mysql_location}/bin
			\cp  -a include ${mysql_location}
		else	
			error_detect "parallel_make"
			error_detect "make install"
			config_mysql 5.5
		fi
		
	elif [ "$mysql" == "${mysql5_6_filename}" ];then
		#安装依赖
		if check_sys packageManager apt;then
			apt-get -y install libncurses5-dev cmake m4 bison
		elif check_sys packageManager yum;then
			#解决CentOS 6 GCC 版本太低的问题
			if check_sys packageManager yum;then
				yum -y install centos-release-scl
				yum -y install devtoolset-6-gcc devtoolset-6-gcc-c++ devtoolset-6-binutils
				echo "source /opt/rh/devtoolset-6/enable" >>/etc/profile
				source /opt/rh/devtoolset-6/enable
			fi
			check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
			yum -y install ncurses-devel m4 bison
		else
			check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
			check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
			check_installed "install_m4" "${depends_prefix}/${m4_filename}"
			check_installed "install_bison" "${depends_prefix}/${bison_filename}"
		fi		
		download_file  "${mysql5_6_filename}.tar.gz"	
		cd $cur_dir/soft/
		rm -rf ${mysql5_6_filename}
		tar xzvf  ${mysql5_6_filename}.tar.gz
		cd ${mysql5_6_filename}
		mkdir build
		cd build
		error_detect "cmake ${mysql_configure_args} .."
		error_detect "parallel_make"
		error_detect "make install"
		config_mysql 5.6

	elif [ "$mysql" == "${mysql5_7_filename}" ];then
		#安装依赖
		if check_sys packageManager apt;then
			apt-get -y install libncurses5-dev cmake m4 bison libssl-dev pkg-config
		elif check_sys packageManager yum;then
			yum -y install ncurses-devel m4 bison openssl-devel pkg-config
			#解决CentOS 6 GCC 版本太低的问题
			if CentOSVerCheck 6;then
				yum -y install centos-release-scl
				yum -y install devtoolset-6-gcc devtoolset-6-gcc-c++ devtoolset-6-binutils
				echo "source /opt/rh/devtoolset-6/enable" >>/etc/profile
				source /opt/rh/devtoolset-6/enable
			fi
			check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
		else
			check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
			check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
			check_installed "install_m4" "${depends_prefix}/${m4_filename}"
			check_installed "install_bison" "${depends_prefix}/${bison_filename}"
			check_installed "install_openssl" "${depends_prefix}/${openssl_filename}"
		fi

		# 下载boost
		download_file "${boost_1_59_filename}.tar.gz"
		cd $cur_dir/soft/
		rm -rf ${boost_1_59_filename}
		tar xzvf ${boost_1_59_filename}.tar.gz

		download_file  "${mysql5_7_filename}.tar.gz"	
		cd $cur_dir/soft/
		rm -rf ${mysql5_7_filename}
		tar xzvf  ${mysql5_7_filename}.tar.gz
		cd ${mysql5_7_filename}
		mkdir build
		cd build
		error_detect "cmake ${mysql_configure_args} .."
		error_detect "parallel_make"
		error_detect "make install"
		config_mysql 5.7	

	elif [ "$mysql" == "${mysql8_0_filename}" ];then
		#安装依赖
		if check_sys packageManager apt;then
			apt-get -y install libncurses5-dev cmake m4 bison
		elif check_sys packageManager yum;then
			yum -y install ncurses-devel m4 bison
			#MySQL 8.0 为 C++14 标准 ，gcc 版本必须在5.3以上
			yum -y install centos-release-scl
			yum -y install devtoolset-6-gcc devtoolset-6-gcc-c++ devtoolset-6-binutils
			echo "source /opt/rh/devtoolset-6/enable" >>/etc/profile
			source /opt/rh/devtoolset-6/enable
		else
			check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
			check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
			check_installed "install_m4" "${depends_prefix}/${m4_filename}"
			check_installed "install_bison" "${depends_prefix}/${bison_filename}"
		fi

		# 下载boost
		download_file "${boost_1_66_filename}.tar.gz"
		cd $cur_dir/soft/
		rm -rf ${boost_1_66_filename}
		tar xzvf ${boost_1_66_filename}.tar.gz

		download_file  "${mysql8_0_filename}.tar.gz"	
		cd $cur_dir/soft/
		rm -rf ${mysql8_0_filename}
		tar xzvf  ${mysql8_0_filename}.tar.gz
		cd ${mysql8_0_filename}
		mkdir build
		cd build
		error_detect "cmake ${mysql_configure_args} .."
		error_detect "parallel_make"
		error_detect "make install"
		config_mysql 8.0			
	fi
	#记录mysql安装位置
	echo "mysql_location=$mysql_location" >> /etc/ezhttp_info_do_not_del

	#解决64位系统php可能找不到mysqlclient的问题
	add_to_env "${mysql_location}"
	if [ -d "${mysql_location}/lib" ] && [ ! -d "${mysql_location}/lib64" ];then
		cd ${mysql_location}
		ln -s lib lib64
	fi
}

#配置mysql
config_mysql(){
	local version=$1
	useradd  -M -s /bin/false mysql
	mkdir -p ${mysql_location}/etc/ ${mysql_data_location}
	#防止mysql使用错误的my.cnf文件
	mv /etc/my.cnf /etc/my.cnf_bak
	mv /etc/mysql/my.cnf /etc/mysql/my.cnf_bak

	#根据系统内存生成my.cnf
	local sysMemory=512M
	local storage=InnoDB
	local totalMemory=$(awk 'NR==1{print $2}' /proc/meminfo)
	if [[ $totalMemory -lt 393216 ]];then
		sysMemory=256M
		storage=MyISAM
	elif [[ $totalMemory -lt 786432 ]];then
		sysMemory=512M
		storage=MyISAM
	elif [[ $totalMemory -lt 1572864 ]];then
		sysMemory=1G
	elif [[ $totalMemory -lt 3145728 ]];then
		sysMemory=2G
	elif [[ $totalMemory -lt 6291456 ]];then
		sysMemory=4G
	elif [[ $totalMemory -lt 12582912 ]];then
		sysMemory=8G
	elif [[ $totalMemory -lt 25165824 ]];then
		sysMemory=16G
	else
		sysMemory=32G
	fi

	make_mysql_my_cnf "$sysMemory" "$storage" "${mysql_data_location}" "true" "false" "${mysql_location}/etc/my.cnf" "${mysql_port_number}"

	#centos 7 does not include perl-Data-Dumper package
	if check_sys sysRelease centos && CentOSVerCheck 7;then
		yum -y install perl-Data-Dumper
	fi

	if [ $version == "5.1" ];then
		rm -f /etc/init.d/mysqld
		\cp  -f ${mysql_location}/share/mysql/mysql.server /etc/init.d/mysqld
		chmod +x /etc/init.d/mysqld
		${mysql_location}/bin/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_data_location}  --defaults-file=${mysql_location}/etc/my.cnf --user=mysql

	elif [ $version == "5.5" ];then
		\cp  -f ${mysql_location}/support-files/mysql.server /etc/init.d/mysqld
		chmod +x /etc/init.d/mysqld
		${mysql_location}/scripts/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_data_location} --defaults-file=${mysql_location}/etc/my.cnf --user=mysql

	elif [ $version == "5.6" ];then
		\cp  -f ${mysql_location}/support-files/mysql.server /etc/init.d/mysqld
		chmod +x /etc/init.d/mysqld
		${mysql_location}/scripts/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_data_location} --defaults-file=${mysql_location}/etc/my.cnf --user=mysql

	elif [ $version == "5.7" ];then
		\cp  -f ${mysql_location}/support-files/mysql.server /etc/init.d/mysqld
		chmod +x /etc/init.d/mysqld
		${mysql_location}/bin/mysqld  --initialize-insecure --basedir=${mysql_location} --datadir=${mysql_data_location} --user=mysql
	elif [ $version == "8.0" ];then
		\cp  -f ${mysql_location}/support-files/mysql.server /etc/init.d/mysqld
		chmod +x /etc/init.d/mysqld
		# 删除query-cache
		sed -i '/query-cache/d' ${mysql_location}/etc/my.cnf		
		${mysql_location}/bin/mysqld  --initialize-insecure --basedir=${mysql_location} --datadir=${mysql_data_location} --user=mysql

	fi

	\cp -f /etc/init.d/mysqld /etc/init.d/mysqld${mysql_port_number}
	chown -R mysql ${mysql_location} ${mysql_data_location}
	cd /usr/bin/
	ln -s $mysql_location/bin/mysql
	ln -s $mysql_location/bin/mysqldump
	boot_start mysqld

	#add to /etc/ld.so.conf.d/mysql.conf
	! grep "${mysql_location}/lib$" /etc/ld.so.conf.d/mysql.conf && echo "${mysql_location}/lib" >> /etc/ld.so.conf.d/mysql.conf
	! grep "${mysql_location}/lib64$" /etc/ld.so.conf.d/mysql.conf && echo "${mysql_location}/lib64" >> /etc/ld.so.conf.d/mysql.conf
	ldconfig
}
