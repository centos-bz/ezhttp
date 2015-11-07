#初始化函数
load_config(){
########################软件包的网盘及官方下载地址设置#######################

###################主要安装包设置###################

#nginx设置
nginx_filename="nginx-1.8.0"
set_md5_val $nginx_filename "3ca4a37931e9fa301964b8ce889da8cb"
nginx_other_link="http://cdn.yyupload.com/down/499809/software/nginx-1.8.0.tar.gz"
nginx_official_link="http://nginx.org/download/nginx-1.8.0.tar.gz"

#tengine设置
tengine_filename="tengine-2.1.0"
set_md5_val $tengine_filename "fb60c57c2610c6a356153613c485e4af"
tengine_other_link="http://cdn.yyupload.com/down/499809/software/tengine-2.1.0.tar.gz"
tengine_official_link="http://tengine.taobao.org/download/tengine-2.1.0.tar.gz"

#openresty设置
openresty_filename="ngx_openresty-1.7.10.2"
set_md5_val $openresty_filename "bca1744196acfb9e986f1fdbee92641e"
openresty_other_link="http://cdn.yyupload.com/down/499809/software/ngx_openresty-1.7.10.2.tar.gz"
openresty_official_link="http://openresty.org/download/ngx_openresty-1.7.10.2.tar.gz"

#apache设置
apache2_2_filename="httpd-2.2.31"
set_md5_val $apache2_2_filename "bc81bdf42a6c10d0ee9e6908014cc0f5"
apache2_2_other_link="http://cdn.yyupload.com/down/499809/software/httpd-2.2.31.tar.gz"
apache2_2_official_link="http://www.webhostingjams.com/mirror/apache//httpd/httpd-2.2.31.tar.gz"

apache2_4_filename="httpd-2.4.17"
set_md5_val $apache2_4_filename "5984049a2311de7173ba545643c450bb"
apache2_4_other_link="http://cdn.yyupload.com/down/499809/software/httpd-2.4.17.tar.gz"
apache2_4_official_link="http://www.webhostingreviewjam.com/mirror/apache//httpd/httpd-2.4.17.tar.gz"

#mysql_server设置
mysql5_1_filename="mysql-5.1.73"
set_md5_val $mysql5_1_filename "887f869bcc757957067b9198f707f32f"
mysql5_1_other_link="http://cdn.yyupload.com/down/499809/software/mysql-5.1.73.tar.gz"
mysql5_1_official_link="http://cdn.mysql.com/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz"

mysql5_5_filename="mysql-5.5.46"
set_md5_val $mysql5_5_filename "7f94c003b672d8edac1fb6adb391b090"
mysql5_5_other_link="http://cdn.yyupload.com/down/499809/software/mysql-5.5.46.tar.gz"
mysql5_5_official_link="http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.46.tar.gz"

mysql5_6_filename="mysql-5.6.27"
set_md5_val $mysql5_6_filename "7754df40bb5567b03b041ccb6b5ddffa"
mysql5_6_other_link="http://cdn.yyupload.com/down/499809/software/mysql-5.6.27.tar.gz"
mysql5_6_official_link="http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.27.tar.gz"

#php设置
php5_2_filename="php-5.2.17"
set_md5_val $php5_2_filename "04d321d5aeb9d3a051233dbd24220ef1"
php5_2_other_link="http://cdn.yyupload.com/down/499809/software/php-5.2.17.tar.gz"
php5_2_official_link="http://museum.php.net/php5/php-5.2.17.tar.gz"

php5_3_filename="php-5.3.29"
set_md5_val $php5_3_filename "ebfa96ea636b2a7ece71e78ad116a338"
php5_3_other_link="http://cdn.yyupload.com/down/499809/software/php-5.3.29.tar.gz"
php5_3_official_link="http://us1.php.net/distributions/php-5.3.29.tar.gz"

php5_4_filename="php-5.4.43"
set_md5_val $php5_4_filename "b09580551c32ba191e926bbbdea4e082"
php5_4_other_link="http://cdn.yyupload.com/down/499809/software/php-5.4.43.tar.gz"
php5_4_official_link="http://us1.php.net/distributions/php-5.4.43.tar.gz"

php5_5_filename="php-5.5.27"
set_md5_val $php5_5_filename "39cc2659f8d777e803816f7b437d9001"
php5_5_other_link="http://cdn.yyupload.com/down/499809/software/php-5.5.27.tar.gz"
php5_5_official_link="http://us1.php.net/distributions/php-5.5.27.tar.gz"

#freetds设置
freetds_filename="freetds-0.95.21"
set_md5_val $freetds_filename "90690b8f2f270151092009b71fe9b590"
freetds_other_link="http://cdn.yyupload.com/down/499809/software/freetds-0.95.21.tar.gz"
freetds_official_link="ftp://ftp.freetds.org/pub/freetds/stable/freetds-0.95.21.tar.gz"

#ZendOptimizer设置
ZendOptimizer_filename="ZendOptimizer-3.3.9"

ZendOptimizer32_filename="ZendOptimizer-3.3.9-linux-glibc23-i386"
set_md5_val $ZendOptimizer32_filename "150586c3af37fbdfa504cf142c447e57"
ZendOptimizer32_other_link="http://cdn.yyupload.com/down/499809/software/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz"
ZendOptimizer32_official_link="http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz"

ZendOptimizer64_filename="ZendOptimizer-3.3.9-linux-glibc23-x86_64"
set_md5_val $ZendOptimizer64_filename "dd4a95e66f0bda61d0006195b2f42efa"
ZendOptimizer64_other_link="http://cdn.yyupload.com/down/499809/software/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz"
ZendOptimizer64_official_link="http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz"

#eaccelerator设置
eaccelerator_filename="eaccelerator-0.9.6.1"
set_md5_val $eaccelerator_filename "32ccd838e06ef5613c2610c1c65ed228"
eaccelerator_other_link="http://cdn.yyupload.com/down/499809/software/eaccelerator-0.9.6.1.tar.bz2"
eaccelerator_official_link="http://cloud.github.com/downloads/eaccelerator/eaccelerator/eaccelerator-0.9.6.1.tar.bz2"

#xcache设置
xcache_filename="xcache-3.2.0"
set_md5_val $xcache_filename "8b0a6f27de630c4714ca261480f34cda"
xcache_other_link="http://cdn.yyupload.com/down/499809/software/xcache-3.2.0.tar.gz"
xcache_official_link="http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz"

#php-memcache设置
php_memcache_filename="memcache-3.0.8"
set_md5_val $php_memcache_filename "24505e9b263d2c77f8ae5e9b4725e7d1"
php_memcache_other_link="http://cdn.yyupload.com/down/499809/software/memcache-3.0.8.tgz"
php_memcache_official_link="http://pecl.php.net/get/memcache-3.0.8.tgz"

#ImageMagick设置
ImageMagick_filename="ImageMagick-6.9.2-5"
set_md5_val $ImageMagick_filename "caa60e6ac24f713d49f527cff2b3a021"
ImageMagick_other_link="http://cdn.yyupload.com/down/499809/software/ImageMagick-6.9.2-5.tar.gz"
ImageMagick_official_link="http://www.imagemagick.org/download/ImageMagick-6.9.2-5.tar.gz"

#php redis模块设置
php_redis_filename="redis-2.2.7"
set_md5_val $php_redis_filename "c55839465b2c435fd091ac50923f2d96"
php_redis_other_link="http://cdn.yyupload.com/down/499809/software/redis-2.2.7.tgz"
php_redis_official_link="http://pecl.php.net/get/redis-2.2.7.tgz"

#php mongo模块设置
php_mongo_filename="mongo-php-driver-1.0.0"
set_md5_val $php_mongo_filename "1d1838e9ee07bacfab861e0b3f448333"
php_mongo_other_link="http://cdn.yyupload.com/down/499809/software/mongo-php-driver-1.0.0.tar.gz"
php_mongo_official_link="https://codeload.github.com/mongodb/mongo-php-driver/tar.gz/1.0.0"

#pkgconfig设置
pkgconfig_filename="pkgconfig-0.18"
set_md5_val $pkgconfig_filename "b20a993728a4df9c366e0582315f7b65"
pkgconfig_other_link="http://cdn.yyupload.com/down/499809/software/pkgconfig-0.18.tar.gz"
pkgconfig_official_link="http://pkgconfig.freedesktop.org/releases/pkgconfig-0.18.tar.gz"

php_imagemagick_filename="imagick-3.1.2"
set_md5_val $php_imagemagick_filename "f2fd71b026debe056e0ec8d76c2ffe94"
php_imagemagick_other_link="http://cdn.yyupload.com/down/499809/software/imagick-3.1.2.tgz"
php_imagemagick_official_link="http://pecl.php.net/get/imagick-3.1.2.tgz"

#APC设置
apc_filename="APC-3.1.13"
set_md5_val $apc_filename "c9e47002e3a67ebde3a6f81437c7b6e0"
apc_other_link="http://cdn.yyupload.com/down/499809/software/APC-3.1.13.tgz"
apc_official_link="http://pecl.php.net/get/APC-3.1.13.tgz"

#ionCube设置
ionCube_filename="ioncube_loaders"

ionCube32_filename="ioncube_loaders_lin_x86"
set_md5_val $ionCube32_filename "272ab5181bd79d45041bb448b07845ab"
ionCube32_other_link="http://cdn.yyupload.com/down/499809/software/ioncube_loaders_lin_x86.tar.gz"
ionCube32_official_link="http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz"

ionCube64_filename="ioncube_loaders_lin_x86-64"
set_md5_val $ionCube64_filename "a5115a5f24f2e9c4d793c5feb78261f2"
ionCube64_other_link="http://cdn.yyupload.com/down/499809/software/ioncube_loaders_lin_x86-64.tar.gz"
ionCube64_official_link="http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"

#ZendGuardLoader设置
ZendGuardLoader_filename="ZendGuardLoader"

ZendGuardLoader53_32_filename="ZendGuardLoader-php-5.3-linux-glibc23-i386"
set_md5_val $ZendGuardLoader53_32_filename "f53e51ecb59e390be5551ff7cc8576b0"
ZendGuardLoader53_32_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz"
ZendGuardLoader53_32_official_link="http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz"

ZendGuardLoader54_32_filename="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386"
set_md5_val $ZendGuardLoader54_32_filename "9a25ff3c2fa4cb37602ba6d6491e859e"
ZendGuardLoader54_32_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz"
ZendGuardLoader54_32_official_link="http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz"

ZendGuardLoader53_64_filename="ZendGuardLoader-php-5.3-linux-glibc23-x86_64"
set_md5_val $ZendGuardLoader53_64_filename "9408297e9e38d5ce2cca92c619b5ad50"
ZendGuardLoader53_64_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz"
ZendGuardLoader53_64_official_link="http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz"

ZendGuardLoader54_64_filename="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64"
set_md5_val $ZendGuardLoader54_64_filename "09d0da0046eb70c3d704db1e0074098e"
ZendGuardLoader54_64_other_link="http://cdn.yyupload.com/down/499809/software/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz"
ZendGuardLoader54_64_official_link="http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz"

#xdebug设置
xdebug_filename="xdebug-XDEBUG_2_2_2"
set_md5_val $xdebug_filename "93e68e45de087909092a979d3922c0cf"
xdebug_other_link="http://cdn.yyupload.com/down/499809/software/xdebug-XDEBUG_2_2_2.tar.gz"
xdebug_official_link="https://github.com/derickr/xdebug/archive/XDEBUG_2_2_2.tar.gz"

#memcached设置
memcached_filename="memcached-1.4.24"
set_md5_val $memcached_filename "4d6e8c90e2068580526c7579dd7f37f6"
memcached_other_link="http://cdn.yyupload.com/down/499809/software/memcached-1.4.24.tar.gz"
memcached_official_link="http://www.memcached.org/files/memcached-1.4.24.tar.gz"

#redis设置
redis_filename="redis-3.0.3"
set_md5_val $redis_filename "76725490d6168cfb4b0ce014b89d4b54"
redis_other_link="http://cdn.yyupload.com/down/499809/software/redis-3.0.3.tar.gz"
redis_official_link="http://download.redis.io/releases/redis-3.0.3.tar.gz"

#phpMyAdmin设置
phpMyAdmin_filename="phpMyAdmin-4.4.12-all-languages"
set_md5_val $phpMyAdmin_filename "37b4fb4ff8681ef8191d03089f21d3fc"
phpMyAdmin_other_link="http://cdn.yyupload.com/down/499809/software/phpMyAdmin-4.4.12-all-languages.tar.gz"
phpMyAdmin_official_link="https://files.phpmyadmin.net/phpMyAdmin/4.4.12/phpMyAdmin-4.4.12-all-languages.tar.gz"

#phpRedisAdmin设置
phpRedisAdmin_filename="phpRedisAdmin-1.1.0"
set_md5_val $phpRedisAdmin_filename "ec34a4c966eaa8fb461e50d76eec1e8d"
phpRedisAdmin_other_link="http://cdn.yyupload.com/down/499809/software/phpRedisAdmin-1.1.0.tar.gz"
phpRedisAdmin_official_link="https://github.com/ErikDubbelboer/phpRedisAdmin/archive/v1.1.0.tar.gz"

#Predis设置(phpRedisAdmin依赖)
Predis_filename="predis-1.0.1"
set_md5_val $Predis_filename "91ea74ee8bb336417cdf139e708fcf43"
Predis_other_link="http://cdn.yyupload.com/down/499809/software/predis-1.0.1.tar.gz"
Predis_official_link="https://github.com/nrk/predis/archive/v1.0.1.tar.gz"

#memadmin设置
memadmin_filename="memadmin-1.0.12"
set_md5_val $memadmin_filename "32ee5b051884cad350b450d30e537909"
memadmin_other_link="http://cdn.yyupload.com/down/499809/software/memadmin-1.0.12.tar.gz"
memadmin_official_link="https://github.com/junstor/memadmin/archive/v1.0.12.tar.gz"

#rockmongo设置
rockmongo_filename="rockmongo-1.1.6-fix-auth"
set_md5_val $rockmongo_filename "80cbe1f3e022cb1290b67cb042c5a97f"
rockmongo_other_link="http://cdn.yyupload.com/down/499809/software/rockmongo-fix-auth.zip"
rockmongo_official_link="https://github.com/centos-bz/rockmongo/archive/fix-auth.zip"

#PureFTPd设置
PureFTPd_filename="pure-ftpd-1.0.41"
set_md5_val $PureFTPd_filename "28a0d0a9384f9e9be289febc7f4b8244"
PureFTPd_other_link="http://cdn.yyupload.com/down/499809/software/pure-ftpd-1.0.41.tar.gz"
PureFTPd_official_link="http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.41.tar.gz"

#user_manager_pureftpd设置
user_manager_pureftpd_filename="ftp_v2.1"
set_md5_val $user_manager_pureftpd_filename "37982c47185e009f7dc54b29ddd7d5fa"
user_manager_pureftpd_other_link="http://cdn.yyupload.com/down/499809/software/ftp_v2.1.tar.gz"
user_manager_pureftpd_official_link="http://machiel.generaal.net/files/pureftpd/ftp_v2.1.tar.gz"

#mongodb设置
mongodb32_filename="mongodb-linux-i686-2.4.9"
set_md5_val $mongodb32_filename "33d4707a4dcb5c32b9c8a3be008d0580"
mongodb32_other_link="http://cdn.yyupload.com/down/499809/software/mongodb-linux-i686-2.4.9.tgz"
mongodb32_official_link="http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.4.9.tgz"

mongodb64_filename="mongodb-linux-x86_64-2.4.9"
set_md5_val $mongodb64_filename "8a82a96d09242e859e225e226e7f47fc"
mongodb64_other_link="http://cdn.yyupload.com/down/499809/software/mongodb-linux-x86_64-2.4.9.tgz"
mongodb64_official_link="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.9.tgz"

mongodbLegacy64_filename="mongodb-linux-x86_64-legacy-2.4.8"
set_md5_val $mongodbLegacy64_filename "6d528120e4749d5508b066177f37de11"
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
set_md5_val $cmake_filename "df5324a3b203373a9e0a04b924281a43"
cmake_other_link="http://cdn.yyupload.com/down/499809/software/cmake-2.8.11.1.tar.gz"
cmake_official_link="http://www.cmake.org/files/v2.8/cmake-2.8.11.1.tar.gz"

#ncurses设置(保持5.8版本)
ncurses_filename="ncurses-5.8"
set_md5_val $ncurses_filename "20ed3fa7599937f0ca268d9088837a64"
ncurses_other_link="http://cdn.yyupload.com/down/499809/software/ncurses-5.8.tar.gz"
ncurses_official_link="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.8.tar.gz"

#ncurses设置(保持5.5版本,用于mysql5.1的安装)
ncurses_filename2="ncurses-5.5"
ncurses_other_link2="http://cdn.yyupload.com/down/499809/software/ncurses-5.5.tar.gz"
ncurses_official_link2="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.5.tar.gz"

#bison设置
bison_filename="bison-2.7"
set_md5_val $bison_filename "ded660799e76fb1667d594de1f7a0da9"
bison_other_link="http://cdn.yyupload.com/down/499809/software/bison-2.7.tar.gz"
bison_official_link="http://ftp.gnu.org/gnu/bison/bison-2.7.tar.gz"

#patch设置
patch_filename="patch-2.7"
set_md5_val $patch_filename "1cbaa223ff4991be9fae8ec1d11fb5ab"
patch_other_link="http://cdn.yyupload.com/down/499809/software/patch-2.7.tar.gz"
patch_official_link="http://ftp.gnu.org/gnu/patch/patch-2.7.tar.gz"

#libiconv设置
libiconv_filename="libiconv-1.14"
set_md5_val $libiconv_filename "e34509b1623cec449dfeb73d7ce9c6c6"
libiconv_other_link="http://cdn.yyupload.com/down/499809/software/libiconv-1.14.tar.gz"
libiconv_official_link="http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz"


#autoconf设置(保持2.59版本)
autoconf_filename="autoconf-2.59"
set_md5_val $autoconf_filename "d4d45eaa1769d45e59dcb131a4af17a0"
autoconf_other_link="http://cdn.yyupload.com/down/499809/software/autoconf-2.59.tar.gz"
autoconf_official_link="http://ftp.gnu.org/gnu/autoconf/autoconf-2.59.tar.gz"

#libxml2设置(保持2-2.8.0版本)
libxml2_filename="libxml2-2.8.0"
set_md5_val $libxml2_filename "c62106f02ee00b6437f0fb9d370c1093"
libxml2_other_link="http://cdn.yyupload.com/down/499809/software/libxml2-2.8.0.tar.gz"
libxml2_official_link="ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz"

#openssl设置 
openssl_filename="openssl-1.0.2d"
set_md5_val $openssl_filename "38dd619b2e77cbac69b99f52a053d25a"
openssl_other_link="http://cdn.yyupload.com/down/499809/software/openssl-1.0.2d.tar.gz"
openssl_official_link="http://www.openssl.org/source/openssl-1.0.2d.tar.gz"

#zlib设置
zlib_filename="zlib-1.2.8"
set_md5_val $zlib_filename "44d667c142d7cda120332623eab69f40"
zlib_other_link="http://cdn.yyupload.com/down/499809/software/zlib-1.2.8.tar.gz"
zlib_official_link="http://zlib.net/zlib-1.2.8.tar.gz"

#libcurl设置
libcurl_filename="curl-7.30.0"
set_md5_val $libcurl_filename "60bb6ff558415b73ba2f00163fd307c5"
libcurl_other_link="http://cdn.yyupload.com/down/499809/software/curl-7.30.0.tar.gz"
libcurl_official_link="http://curl.haxx.se/download/curl-7.30.0.tar.gz"

#pcre设置
pcre_filename="pcre-8.33"
set_md5_val $pcre_filename "94854c93dcc881edd37904bb6ef49ebc"
pcre_other_link="http://cdn.yyupload.com/down/499809/software/pcre-8.33.tar.gz"
pcre_official_link="http://jaist.dl.sourceforge.net/project/pcre/pcre/8.33/pcre-8.33.tar.gz"

#libtool设置
libtool_filename="libtool-2.4"
set_md5_val $libtool_filename "b32b04148ecdd7344abc6fe8bd1bb021"
libtool_other_link="http://cdn.yyupload.com/down/499809/software/libtool-2.4.tar.gz"
libtool_official_link="http://mirrors.kernel.org/gnu/libtool/libtool-2.4.tar.gz"

#libjpeg设置
libjpeg_filename="jpeg-6b"
set_md5_val $libjpeg_filename "dbd5f3b47ed13132f04c685d608a7547"
libjpeg_other_link="http://cdn.yyupload.com/down/499809/software/jpegsrc.v6b.tar.gz"
libjpeg_official_link="http://jaist.dl.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz"

#freetype设置
freetype_filename="freetype-2.5.0"
set_md5_val $freetype_filename "167402d24803591bf88fade74a963a37"
freetype_other_link="http://cdn.yyupload.com/down/499809/software/freetype-2.5.0.tar.gz"
freetype_official_link="http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.tar.gz"

#libpng设置
libpng_filename="libpng-1.6.17"
set_md5_val $libpng_filename "134282f1752dcf4cd81a37b8ff421cef"
libpng_other_link="http://cdn.yyupload.com/down/499809/software/libpng-1.6.17.tar.gz"
libpng_official_link="http://jaist.dl.sourceforge.net/project/libpng/libpng16/1.6.17/libpng-1.6.17.tar.gz"

#mhash设置
mhash_filename="mhash-0.9.9.9"
set_md5_val $mhash_filename "ee66b7d5947deb760aeff3f028e27d25"
mhash_other_link="http://cdn.yyupload.com/down/499809/software/mhash-0.9.9.9.tar.gz"
mhash_official_link="http://jaist.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz"

#libmcrypt设置
libmcrypt_filename="libmcrypt-2.5.8"
set_md5_val $libmcrypt_filename "0821830d930a86a5c69110837c55b7da"
libmcrypt_other_link="http://cdn.yyupload.com/down/499809/software/libmcrypt-2.5.8.tar.gz"
libmcrypt_official_link="http://jaist.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"

#m4设置
m4_filename="m4-1.4.16"
set_md5_val $m4_filename "a5dfb4f2b7370e9d34293d23fd09b280"
m4_other_link="http://cdn.yyupload.com/down/499809/software/m4-1.4.16.tar.gz"
m4_official_link="http://ftp.gnu.org/gnu/m4/m4-1.4.16.tar.gz"

#libevent设置
libevent_filename="libevent-2.0.21-stable"
set_md5_val $libevent_filename "b2405cc9ebf264aa47ff615d9de527a2"
libevent_other_link="http://cdn.yyupload.com/down/499809/software/libevent-2.0.21-stable.tar.gz"
libevent_official_link="http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz"

#apr设置
apr_filename="apr-1.5.2"
set_md5_val $apr_filename "98492e965963f852ab29f9e61b2ad700"
apr_other_link="http://cdn.yyupload.com/down/499809/software/apr-1.5.2.tar.gz"
apr_official_link="http://apache.cs.utah.edu/apr/apr-1.5.2.tar.gz"

#apr-util设置
apr_util_filename="apr-util-1.5.4"
set_md5_val $apr_util_filename "866825c04da827c6e5f53daff5569f42"
apr_util_other_link="http://cdn.yyupload.com/down/499809/software/apr-util-1.5.4.tar.gz"
apr_util_official_link="http://apache.cs.utah.edu//apr/apr-util-1.5.4.tar.gz"

#jailkit设置
jailkit_filename="jailkit-2.17"
set_md5_val $jailkit_filename "7b5a68abe89a65e0e29458cc1fd9ad0b"
jailkit_other_link="http://cdn.yyupload.com/down/499809/software/jailkit-2.17.tar.gz"
jailkit_official_link="http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz"


########################其它设置########################

#nginx apache mysql php等软件菜单设置
nginx_arr=(do_not_install ${nginx_filename} ${tengine_filename} ${openresty_filename} custom_version)
apache_arr=(do_not_install ${apache2_2_filename} ${apache2_4_filename} custom_version)
mysql_arr=(do_not_install ${mysql5_1_filename} ${mysql5_5_filename} ${mysql5_6_filename} libmysqlclient18 custom_version)
php_arr=(do_not_install ${php5_2_filename} ${php5_3_filename} ${php5_4_filename} ${php5_5_filename}  custom_version)
php_mode_arr=(with_apache  with_fastcgi)
php_modules_arr=(do_not_install ${ZendOptimizer_filename} ${ZendGuardLoader_filename} ${xcache_filename} ${eaccelerator_filename} ${php_imagemagick_filename} ${ionCube_filename} ${php_memcache_filename} ${php_redis_filename} ${php_mongo_filename} ${xdebug_filename} mssql)
other_soft_arr=(do_not_install ${memcached_filename} ${PureFTPd_filename} ${phpMyAdmin_filename} ${redis_filename} ${mongodb_filename} ${phpRedisAdmin_filename} ${memadmin_filename} ${rockmongo_filename})

#工具菜单设置
tools_arr=(System_swap_settings Generate_mysql_my_cnf Create_rpm_package Percona_xtrabackup_install Change_sshd_port Iptables_settings Enable_disable_php_extension Set_timezone_and_sync_time Initialize_mysql_server Add_chroot_shell_user Network_analysis Configure_apt_yum_repository Install_rsync_server Backup_setup Count_process_file_access Back_to_main_menu)

#升级软件菜单
upgrade_arr=(Upgrade_nginx_tengine_openresty Back_to_main_menu)

#支持rpm打包的软件
rpm_support_arr=(Nginx Apache PHP MySQL Memcached PureFTPd)

#依赖包安装路径
depends_prefix=/opt/ezhttp

#是否开启多核并行编译,1为开启,0为关闭
parallel_compile=1

#备份配置文件
ini_file="${cur_dir}/backup.ini"


}
