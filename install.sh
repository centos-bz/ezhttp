#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================
#   SYSTEM REQUIRED:  Linux
#   DESCRIPTION:  automatic deploy your linux
#   AUTHOR: Zhu Maohai.
#   website: http://www.centos.bz/ezhttp/
#===============================================================================

#安装nginx
install_nginx(){
#安装pcre
download_file "${pcre_baidupan_link}" "${pcre_official_link}" "${pcre_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${pcre_filename}.tar.gz
#安装openssl
download_file "${openssl_baidupan_link}" "${openssl_official_link}" "${openssl_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${openssl_filename}.tar.gz
#安装zlib
download_file "${zlib_baidupan_link}" "${zlib_official_link}" "${zlib_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${zlib_filename}.tar.gz

if [ "$nginx" == "${nginx_filename}" ];then
	download_file "${nginx_baidupan_link}" "${nginx_official_link}" "${nginx_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xvzf ${nginx_filename}.tar.gz
	cd ${nginx_filename}
	make clean
	error_detect "./configure --prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module --with-http_sub_module --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module"
	error_detect "make"
	error_detect "make install"

elif [ "$nginx" == "${tengine_filename}" ];then
	download_file "${tengine_baidupan_link}" "${tengine_official_link}" "${tengine_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${tengine_filename}.tar.gz
	cd ${tengine_filename}
	make clean
	error_detect "./configure --prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module --with-http_sub_module --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_concat_module --with-http_sysguard_module --with-http_upstream_check_module"
	error_detect "make"
	error_detect "make install"
	
elif [ "$nginx" == "${openresty_filename}" ];then
	download_file "${openresty_baidupan_link}" "${openresty_official_link}" "${openresty_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${openresty_filename}.tar.gz
	cd ${openresty_filename}
	make clean	
	error_detect "./configure --prefix=${nginx_location} --with-luajit --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module --with-http_sub_module --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module"
	error_detect "make"
	error_detect "make install"
	#openresty的nginx路径会在下一级nginx目录
	nginx_location=${nginx_location}/nginx
fi

#配置nginx
config_nginx
#记录nginx安装位置
echo "nginx_location=$nginx_location" >> /tmp/ezhttp_info_do_not_del
}

#配置nginx
config_nginx(){
groupadd www	
useradd -s /bin/false -g www www	
mv ${nginx_location}/conf/nginx.conf ${nginx_location}/conf/nginx.conf_bak
cp -f $cur_dir/conf/*.conf ${nginx_location}/conf/
cp -f $cur_dir/conf/init.d.nginx /etc/init.d/nginx
sed -i "s#^nginx_location=.*#nginx_location=$nginx_location#" /etc/init.d/nginx
chmod +x /etc/init.d/nginx
cp $cur_dir/conf/index.html $nginx_location/html/
cp $cur_dir/conf/tz.php $nginx_location/html/
cp $cur_dir/conf/p.php $nginx_location/html/
}

#安装apache
install_apache(){
#安装依赖
if [ "`check_sys_version`" == "debian" ];then
	apt-get -y install libssl-dev
elif [ "`check_sys_version`" == "centos" ];then
	yum -y install zlib-devel openssl-devel
else
	check_installed "install_zlib " "${depends_prefix}/${zlib_filename}"
	check_installed "install_openssl" "${depends_prefix}/${openssl_filename}"
fi	


if [ "$apache" == "${apache2_2_filename}" ];then	
	download_file "${apache2_2_baidupan_link}" "${apache2_2_official_link}" "${apache2_2_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apache2_2_filename}.tar.gz
	cd ${apache2_2_filename}
	#解决SSL_PROTOCOL_SSLV2’ undeclared问题
	if grep -q -i "Ubuntu 12.04" /etc/issue;then
		sed -i '/SSL_PROTOCOL_SSLV2/d' $cur_dir/soft/${apache2_2_filename}/modules/ssl/ssl_engine_io.c
	fi 	
	make clean
	export LDFLAGS=-ldl
	if [ "`package_support`" == 1 ];then
		other_option=""
	else
		other_option="--with-z=${depends_prefix}/${zlib_filename} --with-ssl=${depends_prefix}/${openssl_filename}"
	fi
	error_detect "./configure --prefix=${apache_location} --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared  --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support ${other_option}"
	error_detect "parallel_make"
	error_detect "make install"
	unset LDFLAGS
	config_apache 2.2

elif [ "$apache" == "${apache2_4_filename}" ];then
	#安装依赖
	if [ "`check_sys_version`" == "debian" ];then
		apt-get -y install libpcre3-dev
	elif [ "`check_sys_version`" == "centos" ];then
		yum install -y pcre-devel
	else
		check_installed "install_pcre" "${depends_prefix}/${pcre_filename}"
	fi		

	#下载apr和apr-util
	download_file "${apr_baidupan_link}" "${apr_official_link}" "${apr_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apr_filename}.tar.gz
	download_file "${apr_util_baidupan_link}" "${apr_util_official_link}" "${apr_util_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apr_util_filename}.tar.gz

	download_file "${apache2_4_baidupan_link}" "${apache2_4_official_link}" "${apache2_4_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apache2_4_filename}.tar.gz
	cd ${apache2_4_filename}
	cp -a ${cur_dir}/soft/${apr_filename} srclib/apr
	cp -a ${cur_dir}/soft/${apr_util_filename} srclib/apr-util
	make clean
	if [ "`package_support`" == 1 ];then
		other_option=""
	else
		other_option="--with-z=${depends_prefix}/${zlib_filename} --with-ssl=${depends_prefix}/${openssl_filename} --with-pcre=${depends_prefix}/${pcre_filename}"
	fi
	error_detect "./configure --prefix=${apache_location} --enable-so --enable-deflate=shared --enable-ssl=shared --enable-expires=shared  --enable-headers=shared --enable-rewrite=shared --enable-static-support  --with-included-apr $other_option"
	error_detect "parallel_make"
	error_detect "make install"
	config_apache 2.4
fi
#记录apache安装位置
echo "apache_location=$apache_location" >> /tmp/ezhttp_info_do_not_del
#清除openssl的LD_LIBRARY_PATH，以后出现no version information available
LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed "s#${depends_prefix}/${pcre_filename}:##")
export LD_LIBRARY_PATH
}

#配置apache
config_apache(){
groupadd www	
useradd -s /bin/false -g www www	
local version=$1
cp -f ${apache_location}/conf/httpd.conf ${apache_location}/conf/httpd.conf_bak
grep -E -q "^\s*#\s*Include conf/extra/httpd-vhosts.conf" ${apache_location}/conf/httpd.conf  && sed -i 's#^\s*\#\s*Include conf/extra/httpd-vhosts.conf#Include conf/extra/httpd-vhosts.conf#' ${apache_location}/conf/httpd.conf || sed -i '$aInclude conf/extra/httpd-vhosts.conf' ${apache_location}/conf/httpd.conf
mv ${apache_location}/conf/extra/httpd-vhosts.conf ${apache_location}/conf/extra/httpd-vhosts.conf_bak

#写入默认虚拟主机配置
cat > ${apache_location}/conf/extra/httpd-vhosts.conf << EOF
NameVirtualHost *:80
<VirtualHost *:80>
ServerName localhost
ServerAlias localhost
DocumentRoot ${apache_location}/htdocs
DirectoryIndex index.php index.html index.htm
<Directory ${apache_location}/htdocs>
Options +Includes -Indexes
AllowOverride All
Order Deny,Allow
Allow from All
php_admin_value open_basedir ${apache_location}/htdocs:/tmp:/proc
</Directory>
</VirtualHost>
EOF

#设置运行用户为www
sed -i 's/^User.*/User www/i' ${apache_location}/conf/httpd.conf
sed -i 's/^Group.*/Group www/i' ${apache_location}/conf/httpd.conf

if [ $version == "2.4" ];then
	sed -i '/NameVirtualHost/d' ${apache_location}/conf/extra/httpd-vhosts.conf
fi

cp -f $cur_dir/conf/init.d.httpd /etc/init.d/httpd
sed -i "s#^apache_location=.*#apache_location=$apache_location#" /etc/init.d/httpd
sed -i "s#^apache_location=.*#apache_location=$apache_location#" /etc/init.d/httpd
chmod +x /etc/init.d/httpd

cp $cur_dir/conf/index.html $apache_location/htdocs/
cp $cur_dir/conf/tz.php $apache_location/htdocs/
cp $cur_dir/conf/p.php $apache_location/htdocs/
}

#安装mysql server
install_mysqld(){
if [ "$mysql" == "${mysql5_1_filename}" ];then

	#安装依赖
	if [ "`check_sys_version`" == "debian" ];then
		apt-get -y install libncurses5-dev
	elif [ "`check_sys_version`" == "centos" ];then
		yum -y install ncurses-devel
	else
		check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
	fi	

	download_file "${mysql5_1_baidupan_link}" "${mysql5_1_official_link}" "${mysql5_1_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${mysql5_1_filename}.tar.gz
	cd ${mysql5_1_filename}
	make clean

	if [ "`package_support`" == 1 ];then
		other_option=""
	else
		other_option="--with-named-curses-libs=${depends_prefix}/${ncurses_filename2}/lib/libncurses.a"
	fi	
	error_detect "./configure --prefix=${mysql_location} --sysconfdir=${mysql_location}/etc --with-unix-socket-path=/tmp/mysql.sock --with-charset=utf8 --with-collation=utf8_general_ci --with-extra-charsets=complex --with-plugins=max --with-mysqld-ldflags=-all-static --enable-assembler $other_option"
	error_detect "parallel_make"
	error_detect "make install"
	config_mysql 5.1

elif [ "$mysql" == "${mysql5_5_filename}" ] || [ "$mysql" == "libmysqlclient18" ];then
	#安装依赖
	if [ "`check_sys_version`" == "debian" ];then
		apt-get -y install libncurses5-dev cmake m4 bison
	elif [ "`check_sys_version`" == "centos" ];then
		yum -y install ncurses-devel cmake m4 bison
	else
		check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
		check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
		check_installed "install_m4" "${depends_prefix}/${m4_filename}"
		check_installed "install_bison" "${depends_prefix}/${bison_filename}"
	fi		

	download_file "${mysql5_5_baidupan_link}" "${mysql5_5_official_link}" "${mysql5_5_filename}.tar.gz"
	cd $cur_dir/soft/
	rm -rf ${mysql5_5_filename}
	tar xzvf ${mysql5_5_filename}.tar.gz
	cd ${mysql5_5_filename}
	make clean
	if [ "`package_support`" == 1 ];then
		other_option=""
	else
		other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
	fi		
	error_detect "cmake -DCMAKE_INSTALL_PREFIX=${mysql_location} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 $other_option"
	#为只编译client作处理
	if [ "$mysql" == "libmysqlclient18" ];then
		error_detect "make mysqlclient libmysql"
		mkdir -p ${mysql_location}/lib ${mysql_location}/bin
		cp -a libmysql/libmysqlclient* ${mysql_location}/lib
		cp -a cp scripts/mysql_config ${mysql_location}/bin
		cp -a include ${mysql_location}
	else	
		error_detect "parallel_make"
		error_detect "make install"
	fi
	config_mysql 5.5
	
elif [ "$mysql" == "${mysql5_6_filename}" ];then
	#安装依赖
	if [ "`check_sys_version`" == "debian" ];then
		apt-get -y install libncurses5-dev cmake m4 bison
	elif [ "`check_sys_version`" == "centos" ];then
		yum -y install ncurses-devel cmake m4 bison
	else
		check_installed "install_ncurses" "${depends_prefix}/${ncurses_filename}"
		check_installed "install_cmake" "${depends_prefix}/${cmake_filename}"
		check_installed "install_m4" "${depends_prefix}/${m4_filename}"
		check_installed "install_bison" "${depends_prefix}/${bison_filename}"
	fi		
	download_file "${mysql5_6_baidupan_link}" "${mysql5_6_official_link}" "${mysql5_6_filename}.tar.gz"	
	cd $cur_dir/soft/
	rm -rf ${mysql5_6_filename}
	tar xzvf  ${mysql5_6_filename}.tar.gz
	cd ${mysql5_6_filename}
	make clean
	if [ "`package_support`" == 1 ];then
		other_option=""
	else
		other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
	fi	
	error_detect "cmake -DCMAKE_INSTALL_PREFIX=${mysql_location} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 $other_option"
	error_detect "parallel_make"
	error_detect "make install"
	config_mysql 5.6
fi
#记录mysql安装位置
echo "mysql_location=$mysql_location" >> /tmp/ezhttp_info_do_not_del

#解决64位系统php可能找不到mysqlclient的问题
add_to_env "${mysql_location}"
[ -d "${mysql_location}/lib" ] && [ -d "${mysql_location}/lib64" ] && cd ${mysql_location}/lib && ln -s ../lib64/mysql

}

#配置mysql
config_mysql(){
local version=$1
useradd -s /bin/false mysql
mkdir -p ${mysql_location}/etc/

if [ $version == "5.1" ];then
	cp -f ${mysql_location}/share/mysql/mysql.server /etc/init.d/mysqld	
	#配置my.cnf
	cp -f $cur_dir/conf/my.cnf_5.1 ${mysql_location}/etc/my.cnf
	sed -i "s:#datadir.*:datadir = ${mysql_data_location}:" ${mysql_location}/etc/my.cnf
	${mysql_location}/bin/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_data_location}  --user=mysql

elif [ $version == "5.5" ];then
	cp -f ${mysql_location}/support-files/mysql.server /etc/init.d/mysqld
	#配置my.cnf
	cp -f $cur_dir/conf/my.cnf_5.5 ${mysql_location}/etc/my.cnf
	sed -i "s:#datadir.*:datadir = ${mysql_data_location}:" ${mysql_location}/etc/my.cnf
	${mysql_location}/scripts/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_data_location}  --user=mysql

elif [ $version == "5.6" ];then
	cp -f ${mysql_location}/support-files/mysql.server /etc/init.d/mysqld
	#配置my.cnf
	cp -f $cur_dir/conf/my.cnf_5.6 ${mysql_location}/etc/my.cnf
	sed -i "s:#datadir.*:datadir = ${mysql_data_location}:" ${mysql_location}/etc/my.cnf
	${mysql_location}/scripts/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_data_location}  --user=mysql

fi

chown -R mysql ${mysql_location} ${mysql_data_location}
cd /usr/bin/
ln -s $mysql_location/bin/mysql
ln -s $mysql_location/bin/mysqldump
}

#安装PHP
install_php(){
#安装php依赖
install_php_depends

#判断是否需要支持php mysql，否则取消php的--with-mysql编译参数
[ "$mysql" == "do_not_install" ] && [ "$mysql_location" == "" ] && unset with_mysql || with_mysql="--with-mysql=$mysql_location --with-mysqli=$mysql_location/bin/mysql_config --with-pdo-mysql=$mysql_location/bin/mysql_config"

#判断是64系统就加上--with-libdir=lib64  
is_64bit && lib64="--with-libdir=lib64" || lib64=""

#解决64位php可能无法找到mysql lib库
if [ "$with_mysql" != "" ];then
	is_64bit && [ ! -d "${mysql_location}/lib64" ] && cd ${mysql_location} && ln -s lib lib64
fi	


if [ "$php" == "${php5_2_filename}" ];then
	#安装依赖
	if [ "`check_sys_version`" == "debian" ];then
		apt-get -y install patch
	elif [ "`check_sys_version`" == "centos" ];then
		yum install -y patch
	else
		check_installed "install_patch" "${depends_prefix}/${patch_filename}"
	fi		
	#判断php运行模式
	if [ "$php_mode" == "with_apache" ];then
		php_run_php_mode="--with-apxs2=${apache_location}/bin/apxs"
	elif [ "$php_mode" == "with_fastcgi" ];then
		php_run_php_mode="--enable-fastcgi --enable-fpm"
	fi
	download_file "${php5_2_baidupan_link}" "${php5_2_official_link}" "${php5_2_filename}.tar.gz"
	cd $cur_dir/soft/
	rm -rf ${php5_2_filename}
	tar xzvf ${php5_2_filename}.tar.gz
	#php-fpm补丁
	gzip -cd $cur_dir/conf/${php5_2_filename}-fpm-0.5.14.diff.gz | patch -d ${php5_2_filename} -p1
	cd ${php5_2_filename}
	#hash漏洞补丁
	cp $cur_dir/conf/${php5_2_filename}-max-input-vars.patch ./
	patch -p1 < ${php5_2_filename}-max-input-vars.patch
	error_detect "./buildconf --force"
	if [ "`package_support`" == 1 ];then
		other_option="--with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-mcrypt --with-mhash "
	else
		other_option="--with-xml-config=${depends_prefix}/${libxml2_filename}/bin/xml2-config --with-libxml-dir=${depends_prefix}/${libxml2_filename} --with-openssl=${depends_prefix}/${openssl_filename} --with-zlib=${depends_prefix}/${zlib_filename} --with-zlib-dir=${depends_prefix}/${zlib_filename} --with-curl=${depends_prefix}/${libcurl_filename} --with-pcre-dir=${depends_prefix}/${pcre_filename} --with-openssl-dir=${depends_prefix}/${openssl_filename} --with-gd --with-jpeg-dir=${depends_prefix}/${libjpeg_filename}  --with-png-dir=${depends_prefix}/${libpng_filename} --with-mcrypt=${depends_prefix}/${libmcrypt_filename} --with-mhash=${depends_prefix}/${mhash_filename}"
	fi		
	error_detect "./configure --prefix=$php_location  --with-config-file-path=${php_location}/etc ${php_run_php_mode} --enable-bcmath --enable-ftp --enable-mbstring --enable-sockets --enable-zip $other_option   ${with_mysql} --without-pear $lib64"
	if grep -q -i "Ubuntu 12.04" /etc/issue;then
		#解决SSL_PROTOCOL_SSLV2’ undeclared问题
		cd ext/openssl/
		patch -p3 < $cur_dir/conf/debian_patches_disable_SSLv2_for_openssl_1_0_0.patch
		cd ../../
	fi	
	error_detect "parallel_make"
	error_detect "make install"
	
	#配置php
	mkdir -p $php_location/etc/
	cp php.ini-recommended $php_location/etc/php.ini
	sed -i "s#extension_dir.*#extension_dir = \"${php_location}/lib/php/extensions/no-debug-non-zts-20060613\"#"  $php_location/etc/php.ini
	
elif [ "$php" == "${php5_3_filename}" ];then
	#判断php运行模式
	if [ "$php_mode" == "with_apache" ];then
		php_run_php_mode="--with-apxs2=${apache_location}/bin/apxs"
	elif [ "$php_mode" == "with_fastcgi" ];then
		php_run_php_mode="--enable-fpm"
	fi
	download_file "${php5_3_baidupan_link}" "${php5_3_official_link}" "${php5_3_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${php5_3_filename}.tar.gz
	cd ${php5_3_filename}
	make clean
	if [ "`package_support`" == 1 ];then
		other_option="--with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-mcrypt --with-mhash"
	else
		other_option="--with-libxml-dir=${depends_prefix}/${libxml2_filename} --with-openssl=${depends_prefix}/${openssl_filename} --with-zlib=${depends_prefix}/${zlib_filename} --with-zlib-dir=${depends_prefix}/${zlib_filename} --with-curl=${depends_prefix}/${libcurl_filename} --with-pcre-dir=${depends_prefix}/${pcre_filename} --with-openssl-dir=${depends_prefix}/${openssl_filename} --with-gd --with-jpeg-dir=${depends_prefix}/${libjpeg_filename}  --with-png-dir=${depends_prefix}/${libpng_filename} --with-mcrypt=${depends_prefix}/${libmcrypt_filename} --with-mhash=${depends_prefix}/${mhash_filename}"
	fi		
	error_detect "./configure --prefix=$php_location --with-config-file-path=${php_location}/etc ${php_run_php_mode} --enable-bcmath --enable-ftp --enable-mbstring --enable-sockets --enable-zip  $other_option  ${with_mysql} --without-pear $lib64"
	error_detect "parallel_make"
	error_detect "make install"	
	
	#配置php
	mkdir -p ${php_location}/etc
	cp php.ini-production $php_location/etc/php.ini
	[ "$php_mode" == "with_fastcgi" ] && cp $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf
	
elif [ "$php" == "${php5_4_filename}" ];then
	#判断php运行模式
	if [ "$php_mode" == "with_apache" ];then
		php_run_php_mode="--with-apxs2=${apache_location}/bin/apxs"
	elif [ "$php_mode" == "with_fastcgi" ];then
		php_run_php_mode="--enable-fpm"
	fi
	download_file "${php5_4_baidupan_link}" "${php5_4_official_link}" "${php5_4_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${php5_4_filename}.tar.gz
	cd ${php5_4_filename}
	make clean
	if [ "`package_support`" == 1 ];then
		other_option="--with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-mcrypt --with-mhash"
	else
		other_option="--with-libxml-dir=${depends_prefix}/${libxml2_filename} --with-openssl=${depends_prefix}/${openssl_filename} --with-zlib=${depends_prefix}/${zlib_filename} --with-zlib-dir=${depends_prefix}/${zlib_filename} --with-curl=${depends_prefix}/${libcurl_filename} --with-pcre-dir=${depends_prefix}/${pcre_filename} --with-openssl-dir=${depends_prefix}/${openssl_filename} --with-gd --with-jpeg-dir=${depends_prefix}/${libjpeg_filename}  --with-png-dir=${depends_prefix}/${libpng_filename} --with-mcrypt=${depends_prefix}/${libmcrypt_filename} --with-mhash=${depends_prefix}/${mhash_filename} "
	fi		
	error_detect "./configure --prefix=$php_location --with-config-file-path=${php_location}/etc ${php_run_php_mode} --enable-bcmath --enable-ftp --enable-mbstring --enable-sockets --enable-zip  $other_option ${with_mysql} --without-pear $lib64"
	error_detect "parallel_make"
	error_detect "make install"	
	
	#配置php
	mkdir -p ${php_location}/etc
	cp php.ini-production $php_location/etc/php.ini	
	[ "$php_mode" == "with_fastcgi" ] && cp $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf
fi
#记录php安装位置
echo "php_location=$php_location" >> /tmp/ezhttp_info_do_not_del
#add php support for apache
[ $php_mode == "with_apache" ] && ! grep -i "Addtype application/x-httpd-php .php" ${apache_location}/conf/httpd.conf && sed -i 's#AddType application/x-gzip .gz .tgz#AddType application/x-gzip .gz .tgz\nAddtype application/x-httpd-php .php#i' ${apache_location}/conf/httpd.conf
[ "$php_mode" == "with_fastcgi" ] && config_php
}

#配置php
config_php(){
groupadd www	
useradd -s /bin/false -g www www

if [ "$php" == "${php5_2_filename}" ];then
	mkdir -p ${php_location}/logs/
	\cp -f $cur_dir/conf/init.d.php-fpm5.2 /etc/init.d/php-fpm
	sed -i "s#^php_location=.*#php_location=$php_location#" /etc/init.d/php-fpm
	chmod +x /etc/init.d/php-fpm
	sed -i  's#.*<value name="user">.*#<value name="user">www</value>#' ${php_location}/etc/php-fpm.conf

elif [ "$php" == "${php5_3_filename}" ]; then
	\cp $cur_dir/soft/${php5_3_filename}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
	chmod +x /etc/init.d/php-fpm
	sed -i 's/^user =.*/user = www/' ${php_location}/etc/php-fpm.conf
	sed -i 's/^group =.*/group = www/' ${php_location}/etc/php-fpm.conf

elif [ "$php" == "${php5_4_filename}" ]; then
	\cp $cur_dir/soft/${php5_4_filename}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
	chmod +x /etc/init.d/php-fpm

fi

}
#安装php模块
install_php_modules(){
local php_prefix=$1
if_in_array "${ZendOptimizer_filename}" "$php_modules_install" && install_ZendOptimizer "$php_prefix"
if_in_array "${eaccelerator_filename}" "$php_modules_install" && install_eaccelerator "$php_prefix"
if_in_array "${php_imagemagick_filename}" "$php_modules_install" && install_php_imagesmagick "$php_prefix"
if_in_array "${php_memcache_filename}" "$php_modules_install" && install_php_memcache "$php_prefix"
if_in_array "${ZendGuardLoader_filename}" "$php_modules_install" && install_ZendGuardLoader "$php_prefix"
if_in_array "${ionCube_filename}" "$php_modules_install" && install_ionCube "$php_prefix"
}

#安装ZendOptimizer
install_ZendOptimizer()
{
local php_prefix=$1	
#如果是64位系统
if is_64bit ; then
	download_file "${ZendOptimizer64_baidupan_link}" "${ZendOptimizer64_official_link}" "${ZendOptimizer64_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ZendOptimizer64_filename}.tar.gz
	mkdir -p ${depends_prefix}/ZendOptimizer
	cp -a ${ZendOptimizer64_filename}/data/5_2_x_comp/ZendOptimizer.so ${depends_prefix}/ZendOptimizer
else
	download_file "${ZendOptimizer32_baidupan_link}" "${ZendOptimizer32_official_link}" "${ZendOptimizer32_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ZendOptimizer32_filename}.tar.gz
	mkdir -p ${depends_prefix}/ZendOptimizer
	cp -a ${ZendOptimizer32_filename}/data/5_2_x_comp/ZendOptimizer.so ${depends_prefix}/ZendOptimizer
fi

#配置php.ini
! grep -q "\[zend_optimizer\]" ${php_prefix}/etc/php.ini  && sed -i "\$a\[zend_optimizer]\nzend_optimizer.optimization_level=15\nzend_extension=${depends_prefix}/ZendOptimizer/ZendOptimizer.so\n" ${php_prefix}/etc/php.ini 
}


#安装eaccelerator
install_eaccelerator(){
#安装依赖
if [ "`check_sys_version`" == "debian" ];then
	apt-get -y install m4 autoconf
elif [ "`check_sys_version`" == "centos" ];then
	yum -y install m4 autoconf
else
	check_installed "install_m4" "${depends_prefix}/${m4_filename}"
	check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"	
fi		

local php_prefix=$1
download_file "${eaccelerator_baidupan_link}" "${eaccelerator_official_link}" "${eaccelerator_filename}.tar.bz2"
cd $cur_dir/soft/
rm -rf ${eaccelerator_filename}
tar xjfv ${eaccelerator_filename}.tar.bz2
cd ${eaccelerator_filename}
make clean
error_detect "${php_prefix}/bin/phpize"
error_detect "./configure --enable-shared --with-php-config=$php_prefix/bin/php-config"
error_detect "parallel_make"
error_detect "make install"
EXTENSION_DIR=`awk -F"= " '/^EXTENSION_DIR/{print $2}' Makefile`

#配置php.ini
! grep -q "\[eaccelerator\]" ${php_prefix}/etc/php.ini && sed -i "/^\[zend_optimizer]\$/i\[eaccelerator]\nzend_extension=\"${EXTENSION_DIR}/eaccelerator.so\"\neaccelerator.cache_dir = \"/var/cache/eaccelerator\"" ${php_prefix}/etc/php.ini

#判断是否已经加上，有可能会因为没有安装zend optimizer而配置失败
! grep -q  "\[eaccelerator\]" ${php_prefix}/etc/php.ini && sed -i "\$a\[eaccelerator]\nzend_extension=\"${EXTENSION_DIR}/eaccelerator.so\"\neaccelerator.cache_dir = \"/var/cache/eaccelerator\"\n" ${php_prefix}/etc/php.ini

#配置缓存目录
mkdir -p /var/cache/eaccelerator
chmod 0777 /var/cache/eaccelerator
}

#安装php-memcache
install_php_memcache(){
#安装依赖
if [ "`check_sys_version`" == "debian" ];then
	apt-get -y install zlib1g-dev m4 autoconf
elif [ "`check_sys_version`" == "centos" ];then
	yum install -y zlib-devel m4 autoconf
else
	check_installed "install_zlib " "${depends_prefix}/${zlib_filename}"
	check_installed "install_m4" "${depends_prefix}/${m4_filename}"
	check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"
fi		

local php_prefix=$1
download_file "${php_memcache_baidupan_link}" "${php_memcache_official_link}" "${php_memcache_filename}.tgz"
cd $cur_dir/soft/
rm -rf ${php_memcache_filename}
tar xzvf ${php_memcache_filename}.tgz
cd ${php_memcache_filename}
error_detect "${php_prefix}/bin/phpize"
if [ "`package_support`" == 1 ];then
	other_option=""
else
	other_option="--with-zlib-dir=${depends_prefix}/${zlib_filename}"
fi
error_detect "./configure --enable-memcache --with-php-config=$php_prefix/bin/php-config $other_option"
error_detect "parallel_make"
error_detect "make install"
! grep -q  "\[memcache\]" ${php_prefix}/etc/php.ini && sed -i '$a\[memcache]\nextension=memcache.so\n' ${php_prefix}/etc/php.ini 
}


#安装php ImageMagick
install_php_imagesmagick(){
#安装依赖
check_installed "install_ImageMagick" "${depends_prefix}/${ImageMagick_filename}"
if [ "`check_sys_version`" == "debian" ];then
	apt-get -y install m4 autoconf pkg-config
elif [ "`check_sys_version`" == "centos" ];then
	yum -y install pkgconfig m4 autoconf
else
	check_installed "install_pkgconfig" "${depends_prefix}/${pkgconfig_filename}"
	check_installed "install_m4" "${depends_prefix}/${m4_filename}"
	check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"

fi	

export PKG_CONFIG_PATH=${depends_prefix}/${ImageMagick_filename}/lib/pkgconfig/
local php_prefix=$1
download_file "${php_imagemagick_baidupan_link}" "${php_imagemagick_official_link}" "${php_imagemagick_filename}.tgz"
cd $cur_dir/soft/
rm -rf ${php_imagemagick_filename}
tar xzvf ${php_imagemagick_filename}.tgz
cd ${php_imagemagick_filename}
error_detect "${php_prefix}/bin/phpize"
error_detect "./configure --with-php-config=$php_prefix/bin/php-config --with-imagick=${depends_prefix}/${ImageMagick_filename}"
error_detect "parallel_make"
error_detect "make install"
! grep -q  "\[imagick\]" ${php_prefix}/etc/php.ini && sed -i '$a\[imagick]\nextension=imagick.so\n' ${php_prefix}/etc/php.ini 
}


#安装ionCube
install_ionCube(){
local php_prefix=$1
if is_64bit ; then
	download_file "${ionCube64_baidupan_link}" "${ionCube64_official_link}" "${ionCube64_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ionCube64_filename}.tar.gz
	mkdir -p ${depends_prefix}/ioncube
	php_version=`check_php_version "$php_prefix"`
	cp ioncube/ioncube_loader_lin_${php_version}.so ${depends_prefix}/ioncube/ioncube.so
else
	download_file "${ionCube32_baidupan_link}" "${ionCube32_official_link}" "${ionCube32_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ionCube32_filename}.tar.gz
	mkdir -p ${depends_prefix}/ioncube
	php_version=`check_php_version "$php_prefix"`
	cp ioncube/ioncube_loader_lin_${php_version}.so ${depends_prefix}/ioncube/ioncube.so
fi
! grep -q  "\[ionCube Loader\]" ${php_prefix}/etc/php.ini && sed -i "/End/a\[ionCube Loader\]\nzend_extension=\"/opt/ezhttp/ioncube/ioncube.so\"\n" ${php_prefix}/etc/php.ini
}

#安装ZendGuardLoader
install_ZendGuardLoader(){
local php_prefix=$1
php_version=`check_php_version "$php_prefix"`
if is_64bit ; then
	if [ "$php_version" == "5.3" ];then
		download_file "${ZendGuardLoader53_64_baidupan_link}" "${ZendGuardLoader53_64_official_link}" "${ZendGuardLoader53_64_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader53_64_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader53_64_filename}/php-5.3.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/
	elif [ "$php_version" == "5.4" ];then
		download_file "${ZendGuardLoader54_64_baidupan_link}" "${ZendGuardLoader54_64_official_link}" "${ZendGuardLoader54_64_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader54_64_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader54_64_filename}/php-5.4.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/		
	fi
else
	if [ "$php_version" == "5.3" ];then
		download_file "${ZendGuardLoader53_32_baidupan_link}" "${ZendGuardLoader53_32_official_link}" "${ZendGuardLoader53_32_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader53_32_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader53_32_filename}/php-5.3.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/
	elif [ "$php_version" == "5.4" ];then
		download_file "${ZendGuardLoader54_32_baidupan_link}" "${ZendGuardLoader54_32_official_link}" "${ZendGuardLoader54_32_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ZendGuardLoader54_32_filename}.tar.gz
		mkdir -p ${depends_prefix}/ZendGuardLoader
		cp ${ZendGuardLoader54_32_filename}/php-5.4.x/ZendGuardLoader.so ${depends_prefix}/ZendGuardLoader/	
	fi
fi

! grep -q  "\[ZendGuardLoader\]" ${php_prefix}/etc/php.ini && sed -i "/End/a\[ZendGuardLoader\]\nzend_extension=\"/${depends_prefix}/ZendGuardLoader/ZendGuardLoader.so\"\n" ${php_prefix}/etc/php.ini

}

#安装其它软件
install_other_soft(){
if_in_array "${memcached_filename}" "$other_soft_install" && install_Memcached
if_in_array "${PureFTPd_filename}" "$other_soft_install" && install_PureFTPd
if_in_array "${phpMyAdmin_filename}" "$other_soft_install" && install_phpmyadmin
}

#安装memcached
install_Memcached(){
#安装依赖
if [ "`check_sys_version`" == "debian" ];then
	apt-get -y install libevent-dev
elif [ "`check_sys_version`" == "centos" ];then
	yum -y install libevent-devel
else
	check_installed "install_libevent" "${depends_prefix}/${libevent_filename}"
fi		

download_file "${memcached_baidupan_link}" "${memcached_official_link}" "${memcached_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${memcached_filename}.tar.gz
cd ${memcached_filename}
make clean
if [ "`package_support`" == 1 ];then
	other_option=""
else
	other_option="--with-libevent=${depends_prefix}/${libevent_filename}"
fi
error_detect "./configure --prefix=$memcached_location $other_option"
error_detect "parallel_make"
error_detect "make install"
cp $cur_dir/conf/memcached-init /etc/init.d/memcached
chmod +x /etc/init.d/memcached
sed -i "s#^memcached_location=.*#memcached_location=$memcached_location#" /etc/init.d/memcached
mkdir -p /var/lock/subsys/
echo "memcached_location=$memcached_location" >> /tmp/ezhttp_info_do_not_del
}

#安装phpMyAdmin
install_phpmyadmin(){
download_file "${phpMyAdmin_baidupan_link}" "${phpMyAdmin_official_link}" "${phpMyAdmin_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${phpMyAdmin_filename}.tar.gz
[ ! -d $phpmyadmin_location ] && mv ${phpMyAdmin_filename} $phpmyadmin_location
#禁用phpmyadmin自动在线检测版本功能，因为在国内有时无法访问检测版本的链接，会导致超时，影响phpmyadmin操作。
sed -i '1aexit;' $phpmyadmin_location/version_check.php
}

#安装PureFTPd
install_PureFTPd(){
download_file "${PureFTPd_baidupan_link}" "${PureFTPd_official_link}" "${PureFTPd_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${PureFTPd_filename}.tar.gz
cd ${PureFTPd_filename}
error_detect "./configure --prefix=$pureftpd_location"
error_detect "parallel_make"
error_detect "make install"
mkdir -p $pureftpd_location/etc
cp -f configuration-file/pure-config.pl $pureftpd_location/bin/pure-config.pl
cp -f configuration-file/pure-ftpd.conf $pureftpd_location/etc
cp -f $cur_dir/conf/init.d.pureftpd /etc/init.d/pureftpd
chmod +x /etc/init.d/pureftpd
sed -i "s#^pureftpd_location=.*#pureftpd_location=$pureftpd_location#" /etc/init.d/pureftpd
chmod +x /usr/local/pureftpd/bin/pure-config.pl
echo "pureftpd_location=$pureftpd_location" >> /tmp/ezhttp_info_do_not_del
}

#提示是否使用上一次的设置
if_use_previous_setting(){
if [ -s "/root/previous_setting" ];then
	#是否使用上次设置安装
	yes_or_no "previous settings found,would you like using the  previous settings from the file /root/previous_setting" ". /root/previous_setting" "advanced_setting"
else
	advanced_setting
fi

}
#高级设置
advanced_setting(){
custom_info=""	
#nginx安装设置
display_menu nginx
#自定义版本支持
if [ "$nginx" == "custom_version" ];then
	while true
	do
		read -p "input version.(ie.nginx-1.4.1 tengine-1.4.6 ngx_openresty-1.2.8.3): " version
		#判断版本号是否有效
		if echo "$version" | grep -q -E '^nginx-[0-9]+\.[0-9]+\.[0-9]+$';then
			nginx_filename=$version
			nginx=$version
			nginx_official_link="http://nginx.org/download/${nginx}.tar.gz"
			nginx_baidupan_link=""
			custom_info="$custom_info\nnginx_filename=$version\nnginx_official_link=$nginx_official_link\nnginx_baidupan_link=''\n"
			break
		elif echo "$version" | grep -q -E '^tengine-[0-9]+\.[0-9]+\.[0-9]+$';then
			tengine_filename=$version
			nginx=$version
			tengine_official_link="http://tengine.taobao.org/download/${nginx}.tar.gz"
			tengine_baidupan_link=""
			custom_info="$custom_info\ntengine_filename=$version\ntengine_official_link=$tengine_official_link\ntengine_baidupan_link=''\n"
			break
		elif echo "$version" | grep -q -E '^ngx_openresty-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$';then
			openresty_filename=$version
			nginx=$version
			openresty_official_link="http://openresty.org/download/${nginx}.tar.gz"
			openresty_baidupan_link=""
			custom_info="$custom_info\nopenresty_filename=$version\nopenresty_official_link=$openresty_official_link\nopenresty_baidupan_link=''\n"
			break
		else
			echo "version invalid,please reinput."
		fi
	done
fi	

if [ "$nginx" != "do_not_install" ];then
	#设置默认路径
	[ "$nginx" == "${openresty_filename}" ] && nginx_default=/usr/local/openresty || nginx_default=/usr/local/nginx
	#nginx安装路径
	read -p "$nginx install location(default:$nginx_default,leave blank for default): " nginx_location
	#设置默认openresty的prefix为/usr/local,则nginx将安装在/usr/local/nginx
	nginx_location=${nginx_location:=$nginx_default}
	nginx_location=`filter_location "$nginx_location"`
	#nginx安装目录会在openresty的下级nginx目录
	[ "$nginx" == "${openresty_filename}" ] && echo "openresty location $nginx_location,nginx location ${nginx_location}/nginx" || echo "$nginx install location: $nginx_location"
fi

#apache安装设置
display_menu apache
#自定义版本支持
if [ "$apache" == "custom_version" ];then
	while true
	do
		read -p "input version.(ie.httpd-2.2.25 httpd-2.4.4): " version
		#判断版本号是否有效
		if echo "$version" | grep -q -E '^httpd-2\.2\.[0-9]+$';then
			apache2_2_filename=$version
			apache=$version
			read -p "please input $apache download url(must be tar.gz file format): "  apache2_2_official_link
			apache2_2_baidupan_link=""
			custom_info="$custom_info\napache2_2_filename=$version\napache2_2_official_link=$apache2_2_official_link\napache2_2_baidupan_link=''\n"
			break
		elif echo "$version" | grep -q -E '^httpd-2\.4\.[0-9]+$';then
			apache2_4_filename=$version
			apache=$version
			read -p "please input $apache download url(must be tar.gz file format): " apache2_4_official_link
			apache2_4_baidupan_link=""
			custom_info="$custom_info\napache2_4_filename=$version\napache2_4_official_link=$apache2_4_official_link\napache2_4_baidupan_link=''\n"
			break
		else
			echo "version invalid,please reinput."
		fi
	done	
fi	

if [ "$apache" != "do_not_install" ];then
	#apache安装路径
	read -p "$apache install location(default:/usr/local/apache,leave blank for default): " apache_location
	apache_location=${apache_location:="/usr/local/apache"}
	apache_location=`filter_location "$apache_location"`
	echo "$apache install location: $apache_location"
fi

#mysql安装设置
display_menu mysql
#自定义版本支持
if [ "$mysql" == "custom_version" ];then
	while true
	do
		read -p "input version.(ie.mysql-5.1.71 mysql-5.5.32 mysql-5.6.12): " version
		#判断版本号是否有效
		if echo "$version" | grep -q -E '^mysql-5\.1\.[0-9]+$';then
			mysql5_1_filename=$version
			mysql=$version
			mysql5_1_official_link="http://cdn.mysql.com/Downloads/MySQL-5.5/${mysql}.tar.gz"
			mysql5_1_baidupan_link=""
			custom_info="$custom_info\nmysql5_1_filename=$version\nmysql5_1_official_link=$mysql5_1_official_link\nmysql5_1_baidupan_link=''\n"
			break
		elif echo "$version" | grep -q -E '^mysql-5\.5\.[0-9]+$';then
			mysql5_5_filename=$version
			mysql=$version
			mysql5_5_official_link="http://cdn.mysql.com/Downloads/MySQL-5.5/${mysql}.tar.gz"
			mysql5_5_baidupan_link=""
			custom_info="$custom_info\nmysql5_5_filename=$version\nmysql5_5_official_link=$mysql5_5_official_link\nmysql5_5_baidupan_link=''\n"
			break
		elif echo "$version" | grep -q -E '^mysql-5\.6\.[0-9]+$';then
			mysql5_6_filename=$version
			mysql=$version
			mysql5_6_official_link="http://cdn.mysql.com/Downloads/MySQL-5.5/${mysql}.tar.gz"
			mysql5_6_baidupan_link=""
			custom_info="$custom_info\nmysql5_6_filename=$version\nmysql5_6_official_link=$mysql5_6_official_link\nmysql5_6_baidupan_link=''\n"
			break			
		else
			echo "version invalid,please reinput."
		fi
	done	
fi	

if [ "$mysql" != "do_not_install" ];then
	#mysql安装路径
	read -p "$mysql install location(default:/usr/local/mysql,leave blank for default): " mysql_location
	mysql_location=${mysql_location:="/usr/local/mysql"}
	mysql_location=`filter_location "$mysql_location"`
	echo "$mysql install location: $mysql_location"
	#当只编译client时，不必输入data和密码
	if [ "$mysql" != "libmysqlclient18" ];then
		#mysql data路径
		read -p "mysql data location(default:${mysql_location}/data,leave blank for default): " mysql_data_location
		mysql_data_location=${mysql_data_location:=$mysql_location/data}
		mysql_data_location=`filter_location "$mysql_data_location"`
		echo "$mysql install location: $mysql_data_location"
		#mysql密码设置
		read -p "mysql server root password (default:root,leave blank for default): " mysql_root_pass
		mysql_root_pass=${mysql_root_pass:=root}
		echo "$mysql root password: $mysql_root_pass"
	fi
fi
#php安装设置
display_menu php
#自定义版本支持
if [ "$php" == "custom_version" ];then
	while true
	do
		read -p "input version.(ie.php-5.2.17 php-5.3.26 php-5.4.16): " version
		#判断版本号是否有效
		if echo "$version" | grep -q -E '^php-5\.2\.[0-9]+$';then
			php5_2_filename=$version
			php=$version
			read -p "please input $php download url(must be tar.gz file format): "  php5_2_official_link
			php5_2_baidupan_link=""
			custom_info="$custom_info\nphp5_2_filename=$version\nphp5_2_official_link=$php5_2_official_link\nphp5_2_baidupan_link''\n"
			break
		elif echo "$version" | grep -q -E '^php-5\.3\.[0-9]+$';then
			php5_3_filename=$version
			php=$version
			read -p "please input $php download url(must be tar.gz file format): " php5_3_official_link
			php5_3_baidupan_link=""
			custom_info="$custom_info\nphp5_3_filename=$version\nphp5_3_official_link=$php5_3_official_link\nphp5_3_baidupan_link''\n"
			break
		elif echo "$version" | grep -q -E '^php-5\.4\.[0-9]+$';then
			php5_4_filename=$version
			php=$version
			read -p "please input $php download url(must be tar.gz file format): " php5_4_official_link
			php5_4_baidupan_link=""
			custom_info="$custom_info\nphp5_4_filename=$version\nphp5_4_official_link=$php5_4_official_link\nphp5_4_baidupan_link''\n"
			break			
		else
			echo "version invalid,please reinput."
		fi
	done	
fi	

if [ "$php" != "do_not_install" ];then
	#选择php运行模式
	while true
	do
		for ((i=1;i<=${#php_mode_arr[@]};i++ )); do echo -e "$i) ${php_mode_arr[$i-1]}"; done
		echo
		read -p "choose php run mode: " mode
		php_mode=${php_mode_arr[$mode-1]}
		#输入有误时，从这里停止重新循环
		[ "$php_mode" == "" ] && continue
		echo "you choose $php_mode"
		#判断当选择with_apache时，apache_location是否已经设置
		if [ "$apache_location" == "" ] && [ "$php_mode" == "with_apache" ];then
			read -p "apache location is not set,please set it: " apache_location
			apache_location=`filter_location "$apache_location"`
		fi	
		#apache2.4与php5.2不兼容，需要判断一下
		if [ "$php_mode" == "with_apache" ] && [ "$apache" == "${apache2_4_filename}" ] && [ "$php" == "${php5_2_filename}" ];then
			echo "${apache2_4_filename} is not compatible with ${php5_2_filename},please reselect"
			display_menu php
		else
			break
		fi	
	done	
	#php安装路径
	read -p "$php install location(default:/usr/local/php,leave blank for default): " php_location
	php_location=${php_location:=/usr/local/php}
	php_location=`filter_location "$php_location"`
	echo "$php install location: $php_location"
	#安装php模块
	echo "#################### PHP modules install ####################"
	echo "$php version available modules:"
	echo
	if [ "$php" == "${php5_2_filename}" ];then
		#因为ZendGuardLoader不支持php5_2，所以从数组中删除
		php_modules_arr=(${php_modules_arr[@]#${ZendGuardLoader_filename}})
		for ((i=1;i<=${#php_modules_arr[@]};i++ )); do echo -e "$i) ${php_modules_arr[$i-1]}"; done
	elif [ "$php" == "${php5_3_filename}" ];then
		#因为ZendOptimizer不支持php5_3,所以从数组中删除
		php_modules_arr=(${php_modules_arr[@]#${ZendOptimizer_filename}})
		for ((i=1;i<=${#php_modules_arr[@]};i++ )); do echo -e "$i) ${php_modules_arr[$i-1]}"; done
	elif [ "$php" == "${php5_4_filename}" ];then
		#从数组中删除ZendOptimizer、eaccelerator、imagick
		php_modules_arr=(${php_modules_arr[@]#${ZendOptimizer_filename}})
		php_modules_arr=(${php_modules_arr[@]#${eaccelerator_filename}})
		php_modules_arr=(${php_modules_arr[@]#${php_imagemagick_filename}})
		for ((i=1;i<=${#php_modules_arr[@]};i++ )); do echo -e "$i) ${php_modules_arr[$i-1]}"; done
	fi
	echo
	php_modules_prompt="please input a number: "
	while true
	do
		read -p "${php_modules_prompt}" php_modules
		php_modules=(${php_modules})
		unset php_modules_install wrong
		for i in ${php_modules[@]}
		do
			if [ "${php_modules_arr[$i-1]}" == "" ];then
				php_modules_prompt="input errors,please input number 1,2,3: ";
				wrong=1
				break
			elif [ "${php_modules_arr[$i-1]}" == "do_not_install" ];then
				unset php_modules_install
				php_modules_install="do_not_install"
				break 2
			else	
				php_modules_install="$php_modules_install ${php_modules_arr[$i-1]}"
				wrong=0
			fi
		done
		[ "$wrong" == 0 ] && break
	done
	echo -e "your php modules selection ${php_modules_install}"
	
	#当选择不安装mysql server时，询问是否让php支持mysql
	if [ "$mysql" == "do_not_install" ];then
		yes_or_no "you do_not_install mysql server,but whether make php support mysql" "read -p 'set mysql server location: ' mysql_location" "unset mysql_location ; echo 'do not make php support mysql.'"
	fi
fi

#安装其它软件

echo  "#################### Other software install ####################"
echo
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

#配置安装路径
if [ "$other_soft_install" != "do_not_install" ];then
	nginx_location=${nginx_location:=/usr/local/nginx}

	if if_in_array "${memcached_filename}" "$other_soft_install";then
		read -p "input $memcached_filename location(default:/usr/local/memcached): " memcached_location
		memcached_location=${memcached_location:=/usr/local/memcached}
		echo "memcached location: $memcached_location"
	fi	

	if if_in_array "${PureFTPd_filename}" "$other_soft_install";then
		read -p "input $PureFTPd_filename location(default:/usr/local/pureftpd): " pureftpd_location
		pureftpd_location=${pureftpd_location:=/usr/local/pureftpd}
		echo "pureftpd location: $pureftpd_location"
	fi	

	if if_in_array "${phpMyAdmin_filename}" "$other_soft_install";then
		[ "php_mode" == "with_apache" ] && default_location="$apache_location/htdocs/phpmyadmin"
		[ "php_mode" == "with_fastcgi" ] && default_location="$nginx_location/html/phpmyadmin"
		read -p "input $phpMyAdmin_filename location(default:$default_location): " phpmyadmin_location
		phpmyadmin_location=${phpmyadmin_location:=$default_location}
		echo "phpmyadmin location: $phpmyadmin_location"
	fi	
fi

#写入设置到临时文件，以备下次重新安装使用
cat >/root/previous_setting <<EOF
nginx="$nginx"
nginx_location="$nginx_location"
apache="$apache"
apache_location="$apache_location"
mysql="$mysql"
mysql_location="$mysql_location"
mysql_data_location="$mysql_data_location"
mysql_root_pass="$mysql_root_pass"
php="$php"
php_location="$php_location"
php_mode="$php_mode"
php_modules_install="${php_modules_install}"
other_soft_install="${other_soft_install}"
memcached_location="${memcached_location}"
pureftpd_location="${pureftpd_location}"
phpmyadmin_location="${phpmyadmin_location}"

EOF
#自定义版本时增加变量
echo -e "$custom_info" >> /root/previous_setting

}

#设置默认选项
load_config(){
if [ -s "$cur_dir/config" ];then
	. $cur_dir/config
else
	echo "$cur_dir/config not found,exit."
	exit 1
fi	
}

#安装前设置
pre_setting(){
#快速安装还是高级设置
while true
do
	#使read能支持回格删除
	stty erase "^H"
	echo -e "1) Quick install,read settings from file config.\n2) Advanced setting.\n3) exit.\n"
	read -p "please select: " quick
	case $quick in
	1) echo "you select quick install." ; load_config ; break;;
	2) echo "you select advanced setting." ; if_use_previous_setting ; break;;
	3) echo "you select exit." ; exit 1;;
	*) echo "input error.";;
	esac
done
sleep 1
clear
echo "#################### your choice overview ####################"
echo
echo "nginx: ${nginx}"
[ "$nginx" != "do_not_install" ] && echo "nginx Location: $nginx_location"
echo "apache: ${apache}"
[ "$apache" != "do_not_install" ] && echo "apache Location: $apache_location"
echo "mysql Server: $mysql"
[ "$mysql" != "do_not_install" ] || [ "$mysql_location" != "" ] && echo "mysql Location: $mysql_location"
[ "$mysql" != "do_not_install" ] || [ "$mysql_data_location" != "" ] &&  echo "mysql Data Location: $mysql_data_location"
[ "$mysql" != "do_not_install" ] || [ "$mysql_root_pass" != "" ] && echo "mysql Root Password: $mysql_root_pass"
echo "PHP Version: $php"
[ "$php" != "do_not_install" ] && echo "PHP Location: $php_location"
[ "$php" != "do_not_install" ] && echo "PHP Modules: ${php_modules_install}"
echo "Other Software: ${other_soft_install}"
if_in_array "${memcached_filename}" "$other_soft_install" && echo "memcached location: $memcached_location"
if_in_array "${PureFTPd_filename}" "$other_soft_install" && echo "pureftpd location: $pureftpd_location"
if_in_array "${phpMyAdmin_filename}" "$other_soft_install" && echo "phpmyadmin_location: $phpmyadmin_location"
echo
echo "##############################################################"
echo
#最终确认是否安装
yes_or_no "Are you ready to configure your Linux" "echo 'start to configure linux...'" "clear ; pre_setting"
}

#完成后的一些配置
post_done(){
echo "start programs..."	
[ $nginx != "do_not_install" ] && /etc/init.d/nginx start
[ $apache != "do_not_install" ] && /etc/init.d/httpd start

if 	[ "$mysql" != "do_not_install" ];then
	#配置mysql
	/etc/init.d/mysqld start
	${mysql_location}/bin/mysqladmin -u root password "$mysql_root_pass"
	#add to path
	! grep -q "${mysql_location}/bin" /etc/profile && echo "PATH=${mysql_location}/bin:$PATH" >> /etc/profile
	. /etc/profile
fi
[ $php != "do_not_install" ] && [ $php_mode == "with_fastcgi" ] && /etc/init.d/php-fpm start
if_in_array "${memcached_filename}" "$other_soft_install" && /etc/init.d/memcached start
if_in_array "${PureFTPd_filename}" "$other_soft_install" && /etc/init.d/pureftpd start
netstat -ntlp
echo "depends_prefix=$depends_prefix" >> /tmp/ezhttp_info_do_not_del
\cp $cur_dir/ez /usr/bin/ez
chmod +x /usr/bin/ez
}

#配置linux
deploy_linux(){
clear
echo "#############################################################################"
echo
echo "You are welcome to use this script to deploy your linux,hope you like."
echo "The script is written by Zhu Maohai."
echo "If you have any question."
echo "please visit http://www.centos.bz/ezhttp/ and submit your question.thank you."
echo
echo "############################################################################"
echo
rootness
pre_setting
disable_selinux
install_tool
[ "$nginx" != "do_not_install" ] && check_installed_ask "install_nginx" "$nginx_location"
[ "$apache" != "do_not_install" ] && check_installed_ask "install_apache" "$apache_location"
[ "$mysql" != "do_not_install" ] && check_installed_ask "install_mysqld" "$mysql_location"
[ "$php" != "do_not_install" ] && check_installed_ask "install_php" "$php_location"
[ "$php_modules_install" != "do_not_install" ] && install_php_modules "$php_location"
[ "$other_soft_install" != "do_not_install" ] && install_other_soft
post_done
}

cur_dir=`pwd`

#初始化
if [ -f $cur_dir/init ];then
	. $cur_dir/init
else
	echo "init file not found.shell script can't be executed."
	exit 1
fi
#载入常用函数
if [ -f $cur_dir/func ];then
	. $cur_dir/func
else
	echo "func file not found.shell script can't be executed."
	exit 1
fi
#创建记录安装路径信息文件
touch /tmp/ezhttp_info_do_not_del
#不允许删除，只允许追加
chattr +a /tmp/ezhttp_info_do_not_del
deploy_linux
