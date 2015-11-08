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

#初始化
if [ -f $cur_dir/function/config.sh ];then
	. $cur_dir/function/config.sh
else
	echo "/config.sh file not found.shell script can't be executed."
	exit 1
fi
#载入常用函数
if [ -f $cur_dir/function/public.sh ];then
	. $cur_dir/function/public.sh
else
	echo "public.sh file not found.shell script can't be executed."
	exit 1
fi

#显示各软件菜单
display_menu nginx
display_menu apache
display_menu mysql
display_menu php
echo "which software you'd install:"
for ((i=1;i<=${#other_soft_arr[@]};i++ )); do echo -e "$i) ${other_soft_arr[$i-1]}"; done
echo
other_prompt="please input a number: "
while true
do
	read -p "${other_prompt}" other_soft
	other_soft=(${other_soft})
	unset other_soft_install wrong
	for j in ${other_soft[@]}
	do
		if [ "${other_soft_arr[$j-1]}" == "" ];then
			other_soft_prompt="input errors,please input number a number: ";
			wrong=1
			break
		elif [ "${other_soft_arr[$j-1]}" == "do_not_install" ];then
			unset other_soft_install
			other_soft_install="do_not_install"
			break 2
		else
			other_soft_install="$other_soft_install ${other_soft_arr[$j-1]}"
			wrong=0
		fi
	done
	[ "$wrong" == 0 ] && break
done
echo -e "your other software selection ${other_soft_install}"

#开始下载软件
#下载nginx
if [ "$nginx" != "do_not_install" ];then

	download_file  "${pcre_filename}.tar.gz"
	download_file  "${openssl_filename}.tar.gz"
	download_file  "${zlib_filename}.tar.gz"

if [ "$nginx" == "${nginx_filename}" ];then
	download_file  "${nginx_filename}.tar.gz"

elif [ "$nginx" == "${tengine_filename}" ];then
	download_file  "${tengine_filename}.tar.gz"
	
elif [ "$nginx" == "${openresty_filename}" ];then
	download_file  "${openresty_filename}.tar.gz"	
fi

fi

#下载apache
if [ "$apache" != "do_not_install" ];then
	download_file  "${zlib_filename}.tar.gz"
	download_file  "${openssl_filename}.tar.gz"

	if [ "$apache" == "${apache2_2_filename}" ];then	
		download_file  "${apache2_2_filename}.tar.gz"

	elif [ "$apache" == "${apache2_4_filename}" ];then
		download_file  "${pcre_filename}.tar.gz"
		#下载apr和apr-util
		download_file  "${apr_filename}.tar.gz"
		download_file  "${apr_util_filename}.tar.gz"
		download_file  "${apache2_4_filename}.tar.gz"
	fi	

fi

#下载mysql
if [ "$mysql" != "do_not_install" ];then
	if [ "$mysql" == "${mysql5_1_filename}" ];then
		download_file  "${ncurses_filename2}.tar.gz"
		download_file  "${mysql5_1_filename}.tar.gz"

	elif [ "$mysql" == "${mysql5_5_filename}" ] || [ "$mysql" == "libmysqlclient18" ];then
		download_file  "${ncurses_filename}.tar.gz"
		download_file  "${cmake_filename}.tar.gz"
		download_file  "${m4_filename}.tar.gz"
		download_file  "${bison_filename}.tar.gz"
		download_file  "${mysql5_5_filename}.tar.gz"
				
	elif [ "$mysql" == "${mysql5_6_filename}" ];then
		download_file  "${ncurses_filename}.tar.gz"
		download_file  "${cmake_filename}.tar.gz"
		download_file  "${m4_filename}.tar.gz"
		download_file  "${bison_filename}.tar.gz"
		download_file  "${mysql5_6_filename}.tar.gz"
		
	fi	
fi

#下载php
if [ "$php" != "do_not_install" ];then
	download_file  "${freetype_filename}.tar.gz"
	download_file  "${libiconv_filename}.tar.gz"
	download_file  "${m4_filename}.tar.gz"
	download_file  "${autoconf_filename}.tar.gz"
	download_file  "${libxml2_filename}.tar.gz"
	download_file  "${openssl_filename}.tar.gz"
	download_file  "${zlib_filename}.tar.gz"
	download_file  "${libcurl_filename}.tar.gz"
	download_file  "${pcre_filename}.tar.gz"
	download_file  "${libtool_filename}.tar.gz"
	download_file  "${libjpeg_filename}.tar.gz"
	download_file  "${libpng_filename}.tar.gz"
	download_file  "${mhash_filename}.tar.gz"
	download_file  "${libmcrypt_filename}.tar.gz"

	if [ "$php" == "${php5_2_filename}" ];then
		download_file  "${patch_filename}.tar.gz"
		download_file  "${php5_2_filename}.tar.gz"
				
	elif [ "$php" == "${php5_3_filename}" ];then
		download_file  "${php5_3_filename}.tar.gz"
				
	elif [ "$php" == "${php5_4_filename}" ];then
		download_file  "${php5_4_filename}.tar.gz"
		
	fi

	#下载php模块
	if if_in_array "${ZendOptimizer_filename}" "$php_modules_install";then 
		download_file  "${ZendOptimizer64_filename}.tar.gz"
		download_file  "${ZendOptimizer32_filename}.tar.gz"
	fi
		
	if if_in_array "${eaccelerator_filename}" "$php_modules_install";then
		download_file  "${m4_filename}.tar.gz"
		download_file  "${autoconf_filename}.tar.gz"
		download_file  "${eaccelerator_filename}.tar.bz2"
	fi
		
	if if_in_array "${php_memcache_filename}" "$php_modules_install";then
		download_file  "${zlib_filename}.tar.gz"
		download_file  "${m4_filename}.tar.gz"
		download_file  "${autoconf_filename}.tar.gz"
		download_file  "${php_memcache_filename}.tgz"
	fi

	if if_in_array "${php_imagemagick_filename}" "$php_modules_install";then
		download_file  "${ImageMagick_filename}.tar.gz"
		download_file  "${pkgconfig_filename}.tar.gz"
		download_file  "${m4_filename}.tar.gz"
		download_file  "${autoconf_filename}.tar.gz"
		download_file  "${php_imagemagick_filename}.tgz"		

	fi	
		
	if if_in_array "${ZendGuardLoader_filename}" "$php_modules_install";then
		download_file  "${ZendGuardLoader53_64_filename}.tar.gz"
		download_file  "${ZendGuardLoader54_64_filename}.tar.gz"
		download_file  "${ZendGuardLoader53_32_filename}.tar.gz"
		download_file  "${ZendGuardLoader54_32_filename}.tar.gz"

	fi
		
	if if_in_array "${ionCube_filename}" "$php_modules_install";then
		download_file  "${ionCube64_filename}.tar.gz"
		download_file  "${ionCube32_filename}.tar.gz"
	fi	

fi

#下载soft
if if_in_array "${memcached_filename}" "$other_soft_install";then
	download_file  "${libevent_filename}.tar.gz"
	download_file  "${memcached_filename}.tar.gz"
fi

if if_in_array "${PureFTPd_filename}" "$other_soft_install";then
	download_file  "${PureFTPd_filename}.tar.gz"
fi

if if_in_array "${phpMyAdmin_filename}" "$other_soft_install";then
	download_file  "${phpMyAdmin_filename}.tar.gz"
fi	

#开始打包
cd $cur_dir
if [[ -s ezhttp_offline.tar.gz ]];then
	echo "file ezhttp_offline.tar.gz had already exsit,please rename or remove."
	exit 1 
else	
	tar czvf ezhttp_offline.tar.gz * && echo "offline package has sucessfully made."
fi	 
