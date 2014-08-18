#初始化函数
load_config(){
########################软件包的网盘及官方下载地址设置#######################

###################主要安装包设置###################

#nginx设置
nginx_filename="nginx-1.6.0"
nginx_other_link="http://cdn.yyupload.com/down/499809/software/nginx-1.6.0.tar.gz"
nginx_official_link="http://nginx.org/download/nginx-1.6.0.tar.gz"

#tengine设置
tengine_filename="tengine-2.0.3"
tengine_other_link="http://cdn.yyupload.com/down/499809/software/tengine-2.0.3.tar.gz"
tengine_official_link="http://tengine.taobao.org/download/tengine-2.0.3.tar.gz"

#openresty设置
openresty_filename="ngx_openresty-1.7.2.1"
openresty_other_link="http://cdn.yyupload.com/down/499809/software/ngx_openresty-1.7.2.1.tar.gz"
openresty_official_link="http://openresty.org/download/ngx_openresty-1.7.2.1.tar.gz"

#apache设置
apache2_2_filename="httpd-2.2.27"
apache2_2_other_link="http://cdn.yyupload.com/down/499809/software/httpd-2.2.27.tar.gz"
apache2_2_official_link="http://psg.mtu.edu/pub/apache//httpd/httpd-2.2.27.tar.gz"

apache2_4_filename="httpd-2.4.10"
apache2_4_other_link="http://cdn.yyupload.com/down/499809/software/httpd-2.4.10.tar.gz"
apache2_4_official_link="http://psg.mtu.edu/pub/apache//httpd/httpd-2.4.10.tar.gz"

#mysql_server设置
mysql5_1_filename="mysql-5.1.73"
mysql5_1_other_link="http://cdn.yyupload.com/down/499809/software/mysql-5.1.73.tar.gz"
mysql5_1_official_link="http://cdn.mysql.com/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz"

mysql5_5_filename="mysql-5.5.38"
mysql5_5_other_link="http://cdn.yyupload.com/down/499809/software/mysql-5.5.38.tar.gz"
mysql5_5_official_link="http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.38.tar.gz"

mysql5_6_filename="mysql-5.6.19"
mysql5_6_other_link="http://cdn.yyupload.com/down/499809/software/mysql-5.6.19.tar.gz"
mysql5_6_official_link="http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.19.tar.gz"

#php设置
php5_2_filename="php-5.2.17"
php5_2_other_link="http://cdn.yyupload.com/down/499809/software/php-5.2.17.tar.gz"
php5_2_official_link="http://centos.googlecode.com/files/php-5.2.17.tar.gz"

php5_3_filename="php-5.3.29"
php5_3_other_link="http://cdn.yyupload.com/down/499809/software/php-5.3.29.tar.gz"
php5_3_official_link="http://us1.php.net/distributions/php-5.3.29.tar.gz"

php5_4_filename="php-5.4.30"
php5_4_other_link="http://cdn.yyupload.com/down/499809/software/php-5.4.30.tar.gz"
php5_4_official_link="http://us1.php.net/distributions/php-5.4.30.tar.gz"

#ZendOptimizer设置
ZendOptimizer_filename="ZendOptimizer-3.3.9"

ZendOptimizer32_filename="ZendOptimizer-3.3.9-linux-glibc23-i386"
ZendOptimizer32_other_link="http://cdn.yyupload.com/down/499809/software/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz"
ZendOptimizer32_official_link="http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz"

ZendOptimizer64_filename="ZendOptimizer-3.3.9-linux-glibc23-x86_64"
ZendOptimizer64_other_link="http://cdn.yyupload.com/down/499809/software/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz"
ZendOptimizer64_official_link="http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz"

#eaccelerator设置
eaccelerator_filename="eaccelerator-0.9.6.1"
eaccelerator_other_link="http://cdn.yyupload.com/down/499809/software/eaccelerator-0.9.6.1.tar.bz2"
eaccelerator_official_link="http://cloud.github.com/downloads/eaccelerator/eaccelerator/eaccelerator-0.9.6.1.tar.bz2"

#xcache设置
xcache_filename="xcache-3.0.4"
xcache_other_link="http://cdn.yyupload.com/down/499809/software/xcache-3.0.4.tar.gz"
xcache_official_link="http://xcache.lighttpd.net/pub/Releases/3.0.4/xcache-3.0.4.tar.gz"

#php-memcache设置
php_memcache_filename="memcache-3.0.8"
php_memcache_other_link="http://cdn.yyupload.com/down/499809/software/memcache-3.0.8.tgz"
php_memcache_official_link="http://pecl.php.net/get/memcache-3.0.8.tgz"

#ImageMagick设置
ImageMagick_filename="ImageMagick-6.8.9-0"
ImageMagick_other_link="http://cdn.yyupload.com/down/499809/software/ImageMagick-6.8.9-0.tar.gz"
ImageMagick_official_link="http://www.imagemagick.org/download/ImageMagick-6.8.9-0.tar.gz"

#php redis模块设置
php_redis_filename="redis-2.2.4"
php_redis_other_link="http://cdn.yyupload.com/down/499809/software/redis-2.2.4.tgz"
php_redis_official_link="http://pecl.php.net/get/redis-2.2.4.tgz"

#php mongo模块设置
php_mongo_filename="mongo-php-driver-1.4.5"
php_mongo_other_link="http://cdn.yyupload.com/down/499809/software/mongo-php-driver-1.4.5.tar.gz"
php_mongo_official_link="https://github.com/mongodb/mongo-php-driver/archive/1.4.5.tar.gz"

#pkgconfig设置
pkgconfig_filename="pkgconfig-0.18"
pkgconfig_other_link="http://cdn.yyupload.com/down/499809/software/pkgconfig-0.18.tar.gz"
pkgconfig_official_link="http://pkgconfig.freedesktop.org/releases/pkgconfig-0.18.tar.gz"

php_imagemagick_filename="imagick-3.1.2"
php_imagemagick_other_link="http://cdn.yyupload.com/down/499809/software/imagick-3.1.2.tgz"
php_imagemagick_official_link="http://pecl.php.net/get/imagick-3.1.2.tgz"

#APC设置
apc_filename="APC-3.1.13"
apc_other_link="http://cdn.yyupload.com/down/499809/software/APC-3.1.13.tgz"
apc_official_link="http://pecl.php.net/get/APC-3.1.13.tgz"

#ionCube设置
ionCube_filename="ioncube_loaders"

ionCube32_filename="ioncube_loaders_lin_x86"
ionCube32_other_link="http://cdn.yyupload.com/down/499809/software/ioncube_loaders_lin_x86.tar.gz"
ionCube32_official_link="http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz"

ionCube64_filename="ioncube_loaders_lin_x86-64"
ionCube64_other_link="http://cdn.yyupload.com/down/499809/software/ioncube_loaders_lin_x86-64.tar.gz"
ionCube64_official_link="http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"

#ZendGuardLoader设置
ZendGuardLoader_filename="ZendGuardLoader"

ZendGuardLoader53_32_filename="ZendGuardLoader-php-5.3-linux-glibc23-i386"
ZendGuardLoader53_32_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz"
ZendGuardLoader53_32_official_link="http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz"

ZendGuardLoader54_32_filename="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386"
ZendGuardLoader54_32_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz"
ZendGuardLoader54_32_official_link="http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz"

ZendGuardLoader53_64_filename="ZendGuardLoader-php-5.3-linux-glibc23-x86_64"
ZendGuardLoader53_64_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz"
ZendGuardLoader53_64_official_link="http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz"

ZendGuardLoader54_64_filename="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64"
ZendGuardLoader54_64_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz"
ZendGuardLoader54_64_official_link="http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz"

#xdebug设置
xdebug_filename="xdebug-XDEBUG_2_2_2"
xdebug_other_link="http://cdn.yyupload.com/down/499809/software/xdebug-XDEBUG_2_2_2.tar.gz"
xdebug_official_link="https://github.com/derickr/xdebug/archive/XDEBUG_2_2_2.tar.gz"

#memcached设置
memcached_filename="memcached-1.4.15"
memcached_other_link="http://cdn.yyupload.com/down/499809/software/memcached-1.4.15.tar.gz"
memcached_official_link="http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz"

#redis设置
redis_filename="redis-2.8.8"
redis_other_link="http://cdn.yyupload.com/down/499809/software/redis-2.8.8.tar.gz"
redis_official_link="http://download.redis.io/releases/redis-2.8.8.tar.gz"

#phpMyAdmin设置
phpMyAdmin_filename="phpMyAdmin-4.0.9-all-languages"
phpMyAdmin_other_link="http://cdn.yyupload.com/down/499809/software/phpMyAdmin-4.0.9-all-languages.tar.gz"
phpMyAdmin_official_link="http://hivelocity.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.0.9/phpMyAdmin-4.0.9-all-languages.tar.gz"

#phpRedisAdmin设置
phpRedisAdmin_filename="phpRedisAdmin-1.1.0"
phpRedisAdmin_other_link="http://cdn.yyupload.com/down/499809/software/phpRedisAdmin-1.1.0.tar.gz"
phpRedisAdmin_official_link="https://github.com/ErikDubbelboer/phpRedisAdmin/archive/v1.1.0.tar.gz"

#Predis设置(phpRedisAdmin依赖)
Predis_filename="predis-0.8.5"
Predis_other_link="http://cdn.yyupload.com/down/499809/software/predis-0.8.5.tar.gz"
Predis_official_link="https://github.com/nrk/predis/archive/v0.8.5.tar.gz"

#memadmin设置
memadmin_filename="memadmin-1.0.12"
memadmin_other_link="http://cdn.yyupload.com/down/499809/software/memadmin-1.0.12.tar.gz"
memadmin_official_link="https://github.com/junstor/memadmin/archive/v1.0.12.tar.gz"

#rockmongo设置
rockmongo_filename="rockmongo-1.1.6-fix-auth"
rockmongo_other_link="http://cdn.yyupload.com/down/499809/software/rockmongo-fix-auth.zip"
rockmongo_official_link="https://github.com/centos-bz/rockmongo/archive/fix-auth.zip"

#PureFTPd设置
PureFTPd_filename="pure-ftpd-1.0.36"
PureFTPd_other_link="http://cdn.yyupload.com/down/499809/software/pure-ftpd-1.0.36.tar.gz"
PureFTPd_official_link="http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.36.tar.gz"

#user_manager_pureftpd设置
user_manager_pureftpd_filename="ftp_v2.1"
user_manager_pureftpd_other_link="http://cdn.yyupload.com/down/499809/software/ftp_v2.1.tar.gz"
user_manager_pureftpd_official_link="http://machiel.generaal.net/files/pureftpd/ftp_v2.1.tar.gz"

#mongodb设置
mongodb32_filename="mongodb-linux-i686-2.4.9"
mongodb32_other_link="http://cdn.yyupload.com/down/499809/software/mongodb-linux-i686-2.4.9.tgz"
mongodb32_official_link="http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.4.9.tgz"

mongodb64_filename="mongodb-linux-x86_64-2.4.9"
mongodb64_other_link="http://cdn.yyupload.com/down/499809/software/mongodb-linux-x86_64-2.4.9.tgz"
mongodb64_official_link="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.9.tgz"

mongodbLegacy64_filename="mongodb-linux-x86_64-legacy-2.4.8"
mongodbLegacy64_other_link="http://cdn.yyupload.com/down/499809/software/mongodb-linux-x86_64-legacy-2.4.8.tgz"
mongodbLegacy64_official_link="http://downloads.mongodb.org/linux/mongodb-linux-x86_64-legacy-2.4.8.tgz"

#根据glibc和系统位数选择mongodb版本
local v1=`ldd --version | awk 'NR==1{print $NF}' | awk -F'.' '{print $1}'`
local v2=`ldd --version | awk 'NR==1{print $NF}' | awk -F'.' '{print $2}'`

mongodb_filename=""
mongodb_other_link=""
mongodb_official_link=""

if [[ $v1 -eq 2 ]]; then
	if [[ $v2 -ge 5 ]];then
		if is_64bit;then
			mongodb_filename="$mongodb64_filename"
			mongodb_other_link="$mongodb64_other_link"
			mongodb_official_link="$mongodb64_official_link"
		else
			mongodb_filename="$mongodb32_filename"
			mongodb_other_link="$mongodb32_other_link"
			mongodb_official_link="$mongodb32_official_link"			
		fi			
	else
		if is_64bit;then
			mongodb_filename="$mongodbLegacy64_filename"
			mongodb_other_link="$mongodbLegacy64_other_link"
			mongodb_official_link="$mongodbLegacy64_official_link"
		fi			
	fi

elif [[ $v1 -gt 2 ]]; then
	if is_64bit;then
		mongodb_filename="$mongodb-linux-x86_64-2.4.9"
		mongodb_other_link="$mongodb64_other_link"
		mongodb_official_link="$mongodb64_official_link"
	else
		mongodb_filename="$mongodb32_filename"
		mongodb_other_link="$mongodb32_other_link"
		mongodb_official_link="$mongodb32_official_link"			
	fi	
fi		


######################依赖包设置######################

#cmake设置
cmake_filename="cmake-2.8.11.1"
cmake_other_link="http://cdn.yyupload.com/down/499809/software/cmake-2.8.11.1.tar.gz"
cmake_official_link="http://www.cmake.org/files/v2.8/cmake-2.8.11.1.tar.gz"

#ncurses设置(保持5.8版本)
ncurses_filename="ncurses-5.8"
ncurses_other_link="http://cdn.yyupload.com/down/499809/software/ncurses-5.8.tar.gz"
ncurses_official_link="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.8.tar.gz"

#ncurses设置(保持5.5版本,用于mysql5.1的安装)
ncurses_filename2="ncurses-5.5"
ncurses_other_link2="http://cdn.yyupload.com/down/499809/software/ncurses-5.5.tar.gz"
ncurses_official_link2="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.5.tar.gz"

#bison设置
bison_filename="bison-2.7"
bison_other_link="http://cdn.yyupload.com/down/499809/software/bison-2.7.tar.gz"
bison_official_link="http://ftp.gnu.org/gnu/bison/bison-2.7.tar.gz"

#patch设置
patch_filename="patch-2.7"
patch_other_link="http://cdn.yyupload.com/down/499809/software/patch-2.7.tar.gz"
patch_official_link="http://ftp.gnu.org/gnu/patch/patch-2.7.tar.gz"

#libiconv设置
libiconv_filename="libiconv-1.14"
libiconv_other_link="http://cdn.yyupload.com/down/499809/software/libiconv-1.14.tar.gz"
libiconv_official_link="http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz"


#autoconf设置(保持2.59版本)
autoconf_filename="autoconf-2.59"
autoconf_other_link="http://cdn.yyupload.com/down/499809/software/autoconf-2.59.tar.gz"
autoconf_official_link="http://ftp.gnu.org/gnu/autoconf/autoconf-2.59.tar.gz"

#libxml2设置(保持2-2.8.0版本)
libxml2_filename="libxml2-2.8.0"
libxml2_other_link="http://cdn.yyupload.com/down/499809/software/libxml2-2.8.0.tar.gz"
libxml2_official_link="ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz"

#openssl设置 
openssl_filename="openssl-1.0.1h"
openssl_other_link="http://cdn.yyupload.com/down/499809/software/openssl-1.0.1h.tar.gz"
openssl_official_link="http://www.openssl.org/source/openssl-1.0.1h.tar.gz"

#zlib设置
zlib_filename="zlib-1.2.8"
zlib_other_link="http://cdn.yyupload.com/down/499809/software/zlib-1.2.8.tar.gz"
zlib_official_link="http://zlib.net/zlib-1.2.8.tar.gz"

#libcurl设置
libcurl_filename="curl-7.30.0"
libcurl_other_link="http://cdn.yyupload.com/down/499809/software/curl-7.30.0.tar.gz"
libcurl_official_link="http://curl.haxx.se/download/curl-7.30.0.tar.gz"

#pcre设置
pcre_filename="pcre-8.33"
pcre_other_link="http://cdn.yyupload.com/down/499809/software/pcre-8.33.tar.gz"
pcre_official_link="http://jaist.dl.sourceforge.net/project/pcre/pcre/8.33/pcre-8.33.tar.gz"

#libtool设置
libtool_filename="libtool-2.4"
libtool_other_link="http://cdn.yyupload.com/down/499809/software/libtool-2.4.tar.gz"
libtool_official_link="http://mirrors.kernel.org/gnu/libtool/libtool-2.4.tar.gz"

#libjpeg设置
libjpeg_filename="jpeg-6b"
libjpeg_other_link="http://cdn.yyupload.com/down/499809/software/jpegsrc.v6b.tar.gz"
libjpeg_official_link="http://hivelocity.dl.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz"

#freetype设置
freetype_filename="freetype-2.5.0"
freetype_other_link="http://cdn.yyupload.com/down/499809/software/freetype-2.5.0.tar.gz"
freetype_official_link="http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.tar.gz"

#libpng设置
libpng_filename="libpng-1.6.9"
libpng_other_link="http://cdn.yyupload.com/down/499809/software/libpng-1.6.9.tar.gz"
libpng_official_link="http://jaist.dl.sourceforge.net/project/libpng/libpng16/1.6.9/libpng-1.6.9.tar.gz"

#mhash设置
mhash_filename="mhash-0.9.9.9"
mhash_other_link="http://cdn.yyupload.com/down/499809/software/mhash-0.9.9.9.tar.gz"
mhash_official_link="http://hivelocity.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz"

#libmcrypt设置
libmcrypt_filename="libmcrypt-2.5.8"
libmcrypt_other_link="http://cdn.yyupload.com/down/499809/software/libmcrypt-2.5.8.tar.gz"
libmcrypt_official_link="http://hivelocity.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"

#m4设置
m4_filename="m4-1.4.16"
m4_other_link="http://cdn.yyupload.com/down/499809/software/m4-1.4.16.tar.gz"
m4_official_link="http://ftp.gnu.org/gnu/m4/m4-1.4.16.tar.gz"

#libevent设置
libevent_filename="libevent-2.0.21-stable"
libevent_other_link="http://cdn.yyupload.com/down/499809/software/libevent-2.0.21-stable.tar.gz"
libevent_official_link="http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz"

#apr设置
apr_filename="apr-1.5.1"
apr_other_link="http://cdn.yyupload.com/down/499809/software/apr-1.5.1.tar.gz"
apr_official_link="http://apache.cs.utah.edu/apr/apr-1.5.1.tar.gz"

#apr-util设置
apr_util_filename="apr-util-1.5.3"
apr_util_other_link="http://cdn.yyupload.com/down/499809/software/apr-util-1.5.3.tar.gz"
apr_util_official_link="http://apache.cs.utah.edu//apr/apr-util-1.5.3.tar.gz"

#jailkit设置
jailkit_filename="jailkit-2.17"
jailkit_other_link="http://cdn.yyupload.com/down/499809/software/jailkit-2.17.tar.gz"
jailkit_official_link="http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz"


########################其它设置########################

#nginx apache mysql php等软件菜单设置
nginx_arr=(do_not_install ${nginx_filename} ${tengine_filename} ${openresty_filename} custom_version)
apache_arr=(do_not_install ${apache2_2_filename} ${apache2_4_filename} custom_version)
mysql_arr=(do_not_install ${mysql5_1_filename} ${mysql5_5_filename} ${mysql5_6_filename} libmysqlclient18 custom_version)
php_arr=(do_not_install ${php5_2_filename} ${php5_3_filename} ${php5_4_filename} custom_version)
php_mode_arr=(with_apache  with_fastcgi)
php_modules_arr=(do_not_install ${ZendOptimizer_filename} ${ZendGuardLoader_filename} ${xcache_filename} ${eaccelerator_filename} ${php_imagemagick_filename} ${ionCube_filename} ${php_memcache_filename} ${php_redis_filename} ${php_mongo_filename} ${xdebug_filename})
other_soft_arr=(do_not_install ${memcached_filename} ${PureFTPd_filename} ${phpMyAdmin_filename} ${redis_filename} ${mongodb_filename} ${phpRedisAdmin_filename} ${memadmin_filename} ${rockmongo_filename})

#工具菜单设置
tools_arr=(System_swap_settings Generate_mysql_my_cnf Create_rpm_package Percona_xtrabackup_install Change_sshd_port Iptables_settings Enable_disable_php_extension Set_timezone_and_sync_time Initialize_mysql_server Add_chroot_shell_user Network_analysis Back_to_main_menu)

#升级软件菜单
upgrade_arr=(Upgrade_nginx_tengine_openresty Back_to_main_menu)

#支持rpm打包的软件
rpm_support_arr=(Nginx Apache PHP MySQL Memcached PureFTPd)

#依赖包安装路径
depends_prefix=/opt/ezhttp

#是否开启多核并行编译,1为开启,0为关闭
parallel_compile=1

}
