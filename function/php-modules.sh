#php模块安装前设置
php_modules_preinstall_settings(){
	echo "#################### PHP modules install ####################"
	phpDoNotInstall=false
	#当php为do_not_install时
	if [[ "$php" == "do_not_install" ]];then
		#作个标记,下面要恢复php变量值为do_not_install
		phpDoNotInstall=true
		php_modules_install=''
		yes_or_no "do you want to install php modules[Y/n]: " "echo 'you select install php modules.'" "echo 'you select do not install php modules'"
		if [[ $yn == "y" ]];then
			while true; do
				read -p "please input the php config location(default:/usr/local/php/bin/php-config): " phpConfig
				phpConfig=${phpConfig:=/usr/local/php/bin/php-config}
				phpConfig=`filter_location "$phpConfig"`
				if check_php_config "$phpConfig";then
					if [[ `get_php_version $phpConfig` == "5.2" ]];then
						php=${php5_2_filename}
					elif [[ `get_php_version $phpConfig` == "5.3" ]]; then
						php=${php5_3_filename}
					elif [[ `get_php_version $phpConfig` == "5.4" ]]; then
						php=${php5_4_filename}
					else
						echo "sorry,unsupported php version."
						exit 1
					fi
					break
				else
					echo "input error,php config $phpConfig is invalid."
				fi
			done
		else
			php_modules_install="do_not_install"
		fi	
	else
		#设置php config路径
		phpConfig=${php_location}/bin/php-config
	fi	

	if [[ $php_modules_install != "do_not_install" ]];then
		echo "$php version available modules:"
		echo
		if [ "$php" == "${php5_2_filename}" ];then
			#因为ZendGuardLoader不支持php5_2，所以从数组中删除
			php_modules_arr=(${php_modules_arr[@]#${ZendGuardLoader_filename}})
		elif [ "$php" == "${php5_3_filename}" ];then
			#因为ZendOptimizer不支持php5_3,所以从数组中删除
			php_modules_arr=(${php_modules_arr[@]#${ZendOptimizer_filename}})
		elif [ "$php" == "${php5_4_filename}" ];then
			#从数组中删除ZendOptimizer、eaccelerator
			php_modules_arr=(${php_modules_arr[@]#${ZendOptimizer_filename}})
			php_modules_arr=(${php_modules_arr[@]#${eaccelerator_filename}})
		fi
		#显示菜单
		display_menu_multi php_modules
		#恢复php变量为do_not_install
		$phpDoNotInstall && php="do_not_install"

		#如果在apache 2.4选择ZendGuardLoader,自动加上--with-mpm=prefork
		[ "$apache" == "$apache2_4_filename" ] && if_in_array "${ZendGuardLoader_filename}" "$php_modules_install" && apache_configure_args="$apache_configure_args --with-mpm=prefork"
	fi	
}


#安装php模块
install_php_modules(){
local phpConfig=$1
if_in_array "${ZendOptimizer_filename}" "$php_modules_install" && install_ZendOptimizer "$phpConfig"
if_in_array "${eaccelerator_filename}" "$php_modules_install" && install_eaccelerator "$phpConfig"
if_in_array "${xcache_filename}" "$php_modules_install" && install_xcache "$phpConfig"
if_in_array "${php_imagemagick_filename}" "$php_modules_install" && install_php_imagesmagick "$phpConfig"
if_in_array "${php_memcache_filename}" "$php_modules_install" && install_php_memcache "$phpConfig"
if_in_array "${ZendGuardLoader_filename}" "$php_modules_install" && install_ZendGuardLoader "$phpConfig"
if_in_array "${ionCube_filename}" "$php_modules_install" && install_ionCube "$phpConfig"
if_in_array "${php_redis_filename}" "$php_modules_install" && install_php_redis "$phpConfig"
if_in_array "${php_mongo_filename}" "$php_modules_install" && install_php_mongo "$phpConfig"
if_in_array "${apc_filename}" "$php_modules_install" && install_php_apc "$phpConfig"
if_in_array "${xdebug_filename}" "$php_modules_install" && install_xdebug "$phpConfig"
}

#安装ZendOptimizer
install_ZendOptimizer()
{
local phpConfig=$1	
#如果是64位系统
if is_64bit ; then
	download_file "${ZendOptimizer64_other_link}" "${ZendOptimizer64_official_link}" "${ZendOptimizer64_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ZendOptimizer64_filename}.tar.gz
	mkdir -p ${depends_prefix}/ZendOptimizer
	cp -a ${ZendOptimizer64_filename}/data/5_2_x_comp/ZendOptimizer.so ${depends_prefix}/ZendOptimizer
else
	download_file "${ZendOptimizer32_other_link}" "${ZendOptimizer32_official_link}" "${ZendOptimizer32_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ZendOptimizer32_filename}.tar.gz
	mkdir -p ${depends_prefix}/ZendOptimizer
	cp -a ${ZendOptimizer32_filename}/data/5_2_x_comp/ZendOptimizer.so ${depends_prefix}/ZendOptimizer
fi

#配置php.ini
! grep -q "\[zend_optimizer\]" $(get_php_ini $phpConfig)  && sed -i "\$a\[zend_optimizer]\nzend_optimizer.optimization_level=15\nzend_extension=${depends_prefix}/ZendOptimizer/ZendOptimizer.so\n" $(get_php_ini $phpConfig) 
}


#安装eaccelerator
install_eaccelerator(){
#安装依赖
if check_sys packageManager apt;then
	apt-get -y install m4 autoconf
elif check_sys packageManager yum;then
	yum -y install m4 autoconf
else
	check_installed "install_m4" "${depends_prefix}/${m4_filename}"
	check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"	
fi		

local phpConfig=$1
download_file "${eaccelerator_other_link}" "${eaccelerator_official_link}" "${eaccelerator_filename}.tar.bz2"
cd $cur_dir/soft/
rm -rf ${eaccelerator_filename}
tar xjfv ${eaccelerator_filename}.tar.bz2
cd ${eaccelerator_filename}
make clean
error_detect "$(dirname $phpConfig)/phpize"
error_detect "./configure --enable-shared --with-php-config=$phpConfig"
error_detect "make"
error_detect "make install"
EXTENSION_DIR=`get_php_extension_dir "$phpConfig"`

#配置php.ini
! grep -q "\[eaccelerator\]" $(get_php_ini $phpConfig) && sed -i "/^\[zend_optimizer]\$/i\[eaccelerator]\nzend_extension=\"${EXTENSION_DIR}/eaccelerator.so\"\neaccelerator.cache_dir = \"/var/cache/eaccelerator\"" $(get_php_ini $phpConfig)

#判断是否已经加上，有可能会因为没有安装zend optimizer而配置失败
! grep -q  "\[eaccelerator\]" $(get_php_ini $phpConfig) && sed -i "\$a\[eaccelerator]\nzend_extension=\"${EXTENSION_DIR}/eaccelerator.so\"\neaccelerator.cache_dir = \"/var/cache/eaccelerator\"\n" $(get_php_ini $phpConfig)

#配置缓存目录
mkdir -p /var/cache/eaccelerator
chmod 0777 /var/cache/eaccelerator
}

#安装xcache
install_xcache(){
local phpConfig=$1
download_file "${xcache_other_link}" "${xcache_official_link}" "${xcache_filename}.tar.gz"
cd $cur_dir/soft/
rm -rf ${xcache_filename}
tar xzvf ${xcache_filename}.tar.gz
cd ${xcache_filename}
error_detect "$(dirname $phpConfig)/phpize"
error_detect "../${xcache_filename}/configure --enable-xcache --enable-xcache-constant --with-php-config=$phpConfig"
error_detect "make"
error_detect "make install"
EXTENSION_DIR=`get_php_extension_dir "$phpConfig"`
#配置php.ini
! grep -q "\[xcache\]" $(get_php_ini $phpConfig) && sed -i '$a\[xcache]\nextension=xcache.so\n' $(get_php_ini $phpConfig) 
}

#安装php-memcache
install_php_memcache(){
#安装依赖
if check_sys packageManager apt;then
	apt-get -y install zlib1g-dev m4 autoconf
elif check_sys packageManager yum;then
	yum install -y zlib-devel m4 autoconf
else
	check_installed "install_zlib " "${depends_prefix}/${zlib_filename}"
	check_installed "install_m4" "${depends_prefix}/${m4_filename}"
	check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"
fi		

local phpConfig=$1
download_file "${php_memcache_other_link}" "${php_memcache_official_link}" "${php_memcache_filename}.tgz"
cd $cur_dir/soft/
rm -rf ${php_memcache_filename}
tar xzvf ${php_memcache_filename}.tgz
cd ${php_memcache_filename}
error_detect "$(dirname $phpConfig)/phpize"
if check_sys packageSupport;then
	other_option=""
else
	other_option="--with-zlib-dir=${depends_prefix}/${zlib_filename}"
fi
error_detect "./configure --enable-memcache --with-php-config=$phpConfig $other_option"
error_detect "make"
error_detect "make install"
! grep -q  "\[memcache\]" $(get_php_ini $phpConfig) && sed -i '$a\[memcache]\nextension=memcache.so\n' $(get_php_ini $phpConfig) 
}

#安装php redis模块
install_php_redis(){
local phpConfig=$1
download_file "${php_redis_other_link}" "${php_redis_official_link}" "${php_redis_filename}.tgz"
cd $cur_dir/soft/
rm -rf ${php_redis_filename}
tar xzvf ${php_redis_filename}.tgz
cd ${php_redis_filename}
error_detect "$(dirname $phpConfig)/phpize"
error_detect "./configure --enable-redis --with-php-config=$phpConfig"
error_detect "make"
error_detect "make install"
! grep -q  "\[redis\]" $(get_php_ini $phpConfig) && sed -i '$a\[redis]\nextension=redis.so\n' $(get_php_ini $phpConfig) 
}

#安装php mongo模块
install_php_mongo(){
local phpConfig=$1
download_file "${php_mongo_other_link}" "${php_mongo_official_link}" "${php_mongo_filename}.tar.gz"
cd $cur_dir/soft/
rm -rf ${php_mongo_filename}
tar xzvf ${php_mongo_filename}.tar.gz
cd ${php_mongo_filename}
error_detect "$(dirname $phpConfig)/phpize"
error_detect "./configure --enable-mongo --with-php-config=$phpConfig"
error_detect "make"
error_detect "make install"
! grep -q  "\[mongo\]" $(get_php_ini $phpConfig) && sed -i '$a\[mongo]\nextension=mongo.so\n' $(get_php_ini $phpConfig) 
}

#安装apc模块
install_php_apc(){
local phpConfig=$1
download_file "${apc_other_link}" "${apc_official_link}" "${apc_filename}.tgz"
cd $cur_dir/soft/
rm -rf ${apc_filename}
tar xzvf ${apc_filename}.tgz
cd ${apc_filename}
error_detect "$(dirname $phpConfig)/phpize"
error_detect "./configure --enable-apc --with-php-config=$phpConfig"
error_detect "make"
error_detect "make install"
! grep -q  "\[apc\]" $(get_php_ini $phpConfig) && sed -i '$a\[apc]\nextension=apc.so\n' $(get_php_ini $phpConfig)
}

#安装php ImageMagick
install_php_imagesmagick(){
#安装依赖
check_installed "install_ImageMagick" "${depends_prefix}/${ImageMagick_filename}"
if check_sys packageManager apt;then
	apt-get -y install m4 autoconf pkg-config
elif check_sys packageManager yum;then
	yum -y install pkgconfig m4 autoconf
else
	check_installed "install_pkgconfig" "${depends_prefix}/${pkgconfig_filename}"
	check_installed "install_m4" "${depends_prefix}/${m4_filename}"
	check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"

fi	

export PKG_CONFIG_PATH=${depends_prefix}/${ImageMagick_filename}/lib/pkgconfig/
local phpConfig=$1
download_file "${php_imagemagick_other_link}" "${php_imagemagick_official_link}" "${php_imagemagick_filename}.tgz"
cd $cur_dir/soft/
rm -rf ${php_imagemagick_filename}
tar xzvf ${php_imagemagick_filename}.tgz
cd ${php_imagemagick_filename}
error_detect "$(dirname $phpConfig)/phpize"
error_detect "./configure --with-php-config=$phpConfig --with-imagick=${depends_prefix}/${ImageMagick_filename}"
error_detect "make"
error_detect "make install"
! grep -q  "\[imagick\]" $(get_php_ini $phpConfig) && sed -i '$a\[imagick]\nextension=imagick.so\n' $(get_php_ini $phpConfig) 
}


#安装ionCube
install_ionCube(){
local phpConfig=$1
#判断php是否为线程安全
if $(get_php_bin $phpConfig) -i | grep "Thread Safety" | grep "enabled";then
	ts="_ts"
elif $(get_php_bin $phpConfig) -i | grep "Thread Safety" | grep "disabled";then
	ts=""
fi

if is_64bit ; then
	download_file "${ionCube64_other_link}" "${ionCube64_official_link}" "${ionCube64_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ionCube64_filename}.tar.gz
	mkdir -p ${depends_prefix}/ioncube
	php_version=`get_php_version "$phpConfig"`
	cp ioncube/ioncube_loader_lin_${php_version}${ts}.so ${depends_prefix}/ioncube/ioncube.so
else
	download_file "${ionCube32_other_link}" "${ionCube32_official_link}" "${ionCube32_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ionCube32_filename}.tar.gz
	mkdir -p ${depends_prefix}/ioncube
	php_version=`get_php_version "$phpConfig"`
	cp ioncube/ioncube_loader_lin_${php_version}${ts}.so ${depends_prefix}/ioncube/ioncube.so
fi
! grep -q  "\[ionCube Loader\]" $(get_php_ini $phpConfig) && sed -i "/End/a\[ionCube Loader\]\nzend_extension=\"/opt/ezhttp/ioncube/ioncube.so\"\n" $(get_php_ini $phpConfig)
}


#安装ZendGuardLoader
install_ZendGuardLoader(){
local phpConfig=$1
php_version=`get_php_version "$phpConfig"`
if is_64bit ; then
	if [ "$php_version" == "5.3" ];then
		download_file "${ZendGuardLoader53_64_other_link}" "${ZendGuardLoader53_64_official_link}" "${ZendGuardLoader53_64_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader53_64_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader53_64_filename}/php-5.3.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/
	elif [ "$php_version" == "5.4" ];then
		download_file "${ZendGuardLoader54_64_other_link}" "${ZendGuardLoader54_64_official_link}" "${ZendGuardLoader54_64_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader54_64_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader54_64_filename}/php-5.4.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/		
	fi
else
	if [ "$php_version" == "5.3" ];then
		download_file "${ZendGuardLoader53_32_other_link}" "${ZendGuardLoader53_32_official_link}" "${ZendGuardLoader53_32_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader53_32_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader53_32_filename}/php-5.3.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/
	elif [ "$php_version" == "5.4" ];then
		download_file "${ZendGuardLoader54_32_other_link}" "${ZendGuardLoader54_32_official_link}" "${ZendGuardLoader54_32_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader54_32_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader54_32_filename}/php-5.4.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/	
	fi
fi

! grep -q  "\[ZendGuardLoader\]" $(get_php_ini $phpConfig) && sed -i "/End/a\[ZendGuardLoader\]\nzend_extension=\"/${depends_prefix}/ZendGuardLoader/ZendGuardLoader.so\"\n" $(get_php_ini $phpConfig)

}

#安装xdebug
install_xdebug(){
local phpConfig=$1
download_file "${xdebug_other_link}" "${xdebug_official_link}" "${xdebug_filename}.tar.gz"
cd $cur_dir/soft/
rm -rf ${xdebug_filename}
tar xzvf ${xdebug_filename}.tar.gz
cd ${xdebug_filename}
error_detect "$(dirname $phpConfig)/phpize"
error_detect "./configure --enable-xdebug --with-php-config=$phpConfig"
error_detect "make"
error_detect "make install"
EXTENSION_DIR=`get_php_extension_dir "$phpConfig"`
! grep -q  "\[xdebug\]" $(get_php_ini $phpConfig) && sed -i "\$a\[xdebug]\nzend_extension=$EXTENSION_DIR/xdebug.so\nxdebug.profiler_enable=0\nxdebug.profiler_output_dir=\"/tmp/xdebug\"\nxdebug.profiler_output_name=\"cachegrind.out.%t\"\nxdebug.profiler_enable_trigger=1\n" $(get_php_ini $phpConfig)

}