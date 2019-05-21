#初始化函数
load_config(){
# 下载链接密钥,有效时间
safe_key="fa5fc23c9b"
allow_seconds=3600

########################软件包的网盘及官方下载地址设置#######################


###################主要安装包设置###################

#nginx设置
nginx_filename="nginx-1.14.2"
set_md5 $nginx_filename "239b829a13cea1d244c1044e830bd9c2"
set_dl $nginx_filename '
https://opensource-1251020419.file.myqcloud.com/nginx/nginx-1.14.2.tar.gz
http://nginx.org/download/nginx-1.14.2.tar.gz
'

#tengine设置
tengine_filename="tengine-2.1.0"
set_md5 $tengine_filename "fb60c57c2610c6a356153613c485e4af"
set_dl $tengine_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/tengine-2.1.0.tar.gz
http://dl-us.centos.bz/ezhttp/tengine-2.1.0.tar.gz
http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
'

#openresty设置
openresty_filename="openresty-1.11.2.2"
set_md5 $openresty_filename "f4b9aa960e57ca692c4d3da731b7e38b"
set_dl $openresty_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/openresty-1.11.2.2.tar.gz
http://dl-us.centos.bz/ezhttp/openresty-1.11.2.2.tar.gz
https://openresty.org/download/openresty-1.11.2.2.tar.gz
'

#apache设置
apache2_2_filename="httpd-2.2.31"
set_md5 $apache2_2_filename "bc81bdf42a6c10d0ee9e6908014cc0f5"
set_dl $apache2_2_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/httpd-2.2.31.tar.gz
http://dl-us.centos.bz/ezhttp/httpd-2.2.31.tar.gz
http://mirror.reverse.net/pub/apache//httpd/httpd-2.2.31.tar.gz
'

apache2_4_filename="httpd-2.4.25"
set_md5 $apache2_4_filename "24fb8b9e36cf131d78caae864fea0f6a"
set_dl $apache2_4_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/httpd-2.4.25.tar.gz
http://dl-us.centos.bz/ezhttp/httpd-2.4.25.tar.gz
http://mirror.reverse.net/pub/apache//httpd/httpd-2.4.25.tar.gz
'

#mysql_server设置
mysql5_1_filename="mysql-5.1.73"
set_md5 $mysql5_1_filename "887f869bcc757957067b9198f707f32f"
set_dl $mysql5_1_filename '
http://dl-us.centos.bz/ezhttp/mysql-5.1.73.tar.gz
http://cdn.mysql.com/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz
http://mirrors.cn99.com/mysql/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz
http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz
'

mysql5_5_filename="mysql-5.5.54"
set_md5 $mysql5_5_filename "358b596e62699397aeee3dfb469f5823"
set_dl $mysql5_5_filename '
http://dl-us.centos.bz/ezhttp/mysql-5.5.54.tar.gz
http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.54.tar.gz
http://mirrors.cn99.com/mysql/Downloads/MySQL-5.5/mysql-5.5.54.tar.gz
http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.5/mysql-5.5.54.tar.gz
'

mysql5_6_filename="mysql-5.6.44"
set_md5 $mysql5_6_filename "caa971e1d346bdb54e1b7470e88c6a9a"
set_dl $mysql5_6_filename '
http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.44.tar.gz
http://mirrors.cn99.com/mysql/Downloads/MySQL-5.6/mysql-5.6.44.tar.gz
http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.6/mysql-5.6.44.tar.gz
'

mysql5_7_filename="mysql-5.7.26"
set_md5 $mysql5_7_filename "5756a63d37d343a39e8e2cf8b13378ba"
set_dl $mysql5_7_filename '
http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.26.tar.gz
http://mirrors.cn99.com/mysql/Downloads/MySQL-5.7/mysql-5.7.26.tar.gz
http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.7/mysql-5.7.26.tar.gz
'
set_hint $mysql5_7_filename "$mysql5_7_filename (need about 2GB RAM when building,try mysql-5.6 if failed)"

mysql8_0_filename="mysql-8.0.16"
set_md5 $mysql8_0_filename "38d5a5c1a1eeed1129fec3a999aa5efd"
set_dl $mysql8_0_filename '
http://cdn.mysql.com/Downloads/MySQL-8.0/mysql-8.0.16.tar.gz
http://mirrors.cn99.com/mysql/Downloads/MySQL-8.0/mysql-8.0.16.tar.gz
http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-8.0/mysql-8.0.16.tar.gz
'


# boost设置(mysql5.6依赖)

boost_1_59_filename="boost_1_59_0"
set_md5 $boost_1_59_filename "51528a0e3b33d9e10aaa311d9eb451e3"
set_dl $boost_1_59_filename '
https://opensource-1251020419.file.myqcloud.com/boost/boost_1_59_0.tar.gz
https://nchc.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
https://jaist.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
http://sourceforge.mirrorservice.org/b/bo/boost/boost/1.59.0/boost_1_59_0.tar.gz
'

boost_1_66_filename="boost_1_66_0"
set_md5 $boost_1_66_filename "d275cd85b00022313c171f602db59fc5"
set_dl $boost_1_66_filename '
https://opensource-1251020419.file.myqcloud.com/boost/boost_1_66_0.tar.gz
https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz
http://dl-us.centos.bz/ezhttp/boost_1_66_0.tar.gz
http://jaist.dl.sourceforge.net/project/boost/boost/1.66.0/boost_1_66_0.tar.gz
http://sourceforge.mirrorservice.org/b/bo/boost/boost/1.66.0/boost_1_66_0.tar.gz
'

#php设置
php5_2_filename="php-5.2.17"
set_md5 $php5_2_filename "04d321d5aeb9d3a051233dbd24220ef1"
set_dl $php5_2_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/php-5.2.17.tar.gz
http://dl-us.centos.bz/ezhttp/php-5.2.17.tar.gz
http://museum.php.net/php5/php-5.2.17.tar.gz
'

php5_3_filename="php-5.3.29"
set_md5 $php5_3_filename "ebfa96ea636b2a7ece71e78ad116a338"
set_dl $php5_3_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/php-5.3.29.tar.gz
http://dl-us.centos.bz/ezhttp/php-5.3.29.tar.gz
http://us1.php.net/distributions/php-5.3.29.tar.gz
'

php5_4_filename="php-5.4.43"
set_md5 $php5_4_filename "b09580551c32ba191e926bbbdea4e082"
set_dl $php5_4_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/php-5.4.43.tar.gz
http://dl-us.centos.bz/ezhttp/php-5.4.43.tar.gz
http://us1.php.net/distributions/php-5.4.43.tar.gz
'

php5_5_filename="php-5.5.27"
set_md5 $php5_5_filename "39cc2659f8d777e803816f7b437d9001"
set_dl $php5_5_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/php-5.5.27.tar.gz
http://dl-us.centos.bz/ezhttp/php-5.5.27.tar.gz
http://us1.php.net/distributions/php-5.5.27.tar.gz
'

php5_6_filename="php-5.6.15"
set_md5 $php5_6_filename "4ec2fe201e24c6f65bf7bd4bac1bc880"
set_dl $php5_6_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/php-5.6.15.tar.gz
http://dl-us.centos.bz/ezhttp/php-5.6.15.tar.gz
http://us1.php.net/distributions/php-5.6.15.tar.gz
'

php7_1_filename="php-7.1.29"
set_md5 $php7_1_filename "71a43101a0f44d409851d7f62f10a030"
set_dl $php7_1_filename '
https://opensource-1251020419.file.myqcloud.com/php/php-7.1.29.tar.gz
http://dl-us.centos.bz/ezhttp/php-7.1.29.tar.gz
https://www.php.net/distributions/php-7.1.29.tar.gz
'

php7_2_filename="php-7.2.18"
set_md5 $php7_2_filename "30333c28bbbbcc296cb80c0a9b059356"
set_dl $php7_2_filename '
https://opensource-1251020419.file.myqcloud.com/php/php-7.2.18.tar.gz
https://www.php.net/distributions/php-7.2.18.tar.gz
'

php7_3_filename="php-7.3.5"
set_md5 $php7_3_filename "8cca50c78c38ff2c92f9aa65a9c3894b"
set_dl $php7_3_filename '
https://opensource-1251020419.file.myqcloud.com/php/php-7.3.5.tar.gz
https://www.php.net/distributions/php-7.3.5.tar.gz
'

#libzip设置
libzip_filename="libzip-1.5.2"
set_md5 $libzip_filename "8db7145801889ecf7ab481b23d6487cd"
set_dl $libzip_filename '
https://opensource-1251020419.file.myqcloud.com/libzip/libzip-1.5.2.tar.gz
https://libzip.org/download/libzip-1.5.2.tar.gz
'

#freetds设置
freetds_filename="freetds-0.95.21"
set_md5 $freetds_filename "90690b8f2f270151092009b71fe9b590"
set_dl $freetds_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/freetds-0.95.21.tar.gz
http://dl-us.centos.bz/ezhttp/freetds-0.95.21.tar.gz
ftp://ftp.freetds.org/pub/freetds/stable/freetds-0.95.21.tar.gz
'

#swoole设置
swoole_filename="swoole-src-swoole-1.7.20-stable"
set_md5 $swoole_filename "c44284e20d415ac06db512f3fb1f9863"
set_dl $swoole_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/swoole-src-swoole-1.7.20-stable.tar.gz
http://dl-us.centos.bz/ezhttp/swoole-src-swoole-1.7.20-stable.tar.gz
https://codeload.github.com/swoole/swoole-src/tar.gz/swoole-1.7.20-stable
'
set_hint $swoole_filename "php-swoole-1.7.20"

#ZendOptimizer设置
ZendOptimizer_filename="ZendOptimizer-3.3.9"

ZendOptimizer32_filename="ZendOptimizer-3.3.9-linux-glibc23-i386"
set_md5 $ZendOptimizer32_filename "150586c3af37fbdfa504cf142c447e57"
set_dl $ZendOptimizer32_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz
http://dl-us.centos.bz/ezhttp/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz
http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz
'

ZendOptimizer64_filename="ZendOptimizer-3.3.9-linux-glibc23-x86_64"
set_md5 $ZendOptimizer64_filename "dd4a95e66f0bda61d0006195b2f42efa"
set_dl $ZendOptimizer64_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
http://dl-us.centos.bz/ezhttp/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
'

#eaccelerator设置
eaccelerator_filename="eaccelerator-0.9.6.1"
set_md5 $eaccelerator_filename "32ccd838e06ef5613c2610c1c65ed228"
set_dl $eaccelerator_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/eaccelerator-0.9.6.1.tar.bz2
http://dl-us.centos.bz/ezhttp/eaccelerator-0.9.6.1.tar.bz2
http://cloud.github.com/downloads/eaccelerator/eaccelerator/eaccelerator-0.9.6.1.tar.bz2
'

#gmp设置
gmp_filename="gmp-6.1.0"
set_md5 $gmp_filename "86ee6e54ebfc4a90b643a65e402c4048"
set_dl $gmp_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/gmp-6.1.0.tar.bz2
http://dl-us.centos.bz/ezhttp/gmp-6.1.0.tar.bz2
https://gmplib.org/download/gmp/gmp-6.1.0.tar.bz2
'
set_hint $gmp_filename "php-${gmp_filename}"

#xcache设置
xcache_filename="xcache-3.2.0"
set_md5 $xcache_filename "8b0a6f27de630c4714ca261480f34cda"
set_dl $xcache_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/xcache-3.2.0.tar.gz
http://dl-us.centos.bz/ezhttp/xcache-3.2.0.tar.gz
http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz
'

#php-memcache设置
php_memcache_filename="memcache-3.0.8"
set_md5 $php_memcache_filename "24505e9b263d2c77f8ae5e9b4725e7d1"
set_dl $php_memcache_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/memcache-3.0.8.tgz
http://dl-us.centos.bz/ezhttp/memcache-3.0.8.tgz
http://pecl.php.net/get/memcache-3.0.8.tgz
'
set_hint $php_memcache_filename "php-${php_memcache_filename}"

#ImageMagick设置
ImageMagick_filename="ImageMagick-7.0.4-0"
set_md5 $ImageMagick_filename "b96e1d23d838ca132c2d99d55f5c2f77"
set_dl $ImageMagick_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ImageMagick-7.0.4-0.tar.xz
http://dl-us.centos.bz/ezhttp/ImageMagick-7.0.4-0.tar.xz
http://www.imagemagick.org/download/releases/ImageMagick-7.0.4-0.tar.xz
'

#php redis模块设置
php_redis_filename="redis-2.2.7"
set_md5 $php_redis_filename "c55839465b2c435fd091ac50923f2d96"
set_dl $php_redis_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/redis-2.2.7.tgz
http://dl-us.centos.bz/ezhttp/redis-2.2.7.tgz
http://pecl.php.net/get/redis-2.2.7.tgz
'
set_hint $php_redis_filename "php-${php_redis_filename}"

#php mongo模块设置
php_mongo_filename="mongo-php-driver-legacy-1.6.11"
set_md5 $php_mongo_filename "674b8598202fff91c90341cfb0e2e25e"
set_dl $php_mongo_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/mongo-php-driver-legacy-1.6.11.tar.gz
http://dl-us.centos.bz/ezhttp/mongo-php-driver-legacy-1.6.11.tar.gz
https://codeload.github.com/mongodb/mongo-php-driver-legacy/tar.gz/1.6.11
'
set_hint $php_mongo_filename "php-mongo-legacy-1.6.11"

#pkgconfig设置
pkgconfig_filename="pkgconfig-0.18"
set_md5 $pkgconfig_filename "b20a993728a4df9c366e0582315f7b65"
set_dl $pkgconfig_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/pkgconfig-0.18.tar.gz
http://dl-us.centos.bz/ezhttp/pkgconfig-0.18.tar.gz
http://pkgconfig.freedesktop.org/releases/pkgconfig-0.18.tar.gz
'

php_imagemagick_filename="imagick-3.1.2"
set_md5 $php_imagemagick_filename "f2fd71b026debe056e0ec8d76c2ffe94"
set_dl $php_imagemagick_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/imagick-3.1.2.tgz
http://dl-us.centos.bz/ezhttp/imagick-3.1.2.tgz
http://pecl.php.net/get/imagick-3.1.2.tgz
'
set_hint $php_imagemagick_filename "php-imagick-3.1.2"

#APC设置
apc_filename="APC-3.1.13"
set_md5 $apc_filename "c9e47002e3a67ebde3a6f81437c7b6e0"
set_dl $apc_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/APC-3.1.13.tgz
http://dl-us.centos.bz/ezhttp/APC-3.1.13.tgz
http://pecl.php.net/get/APC-3.1.13.tgz
'

#ionCube设置
ionCube_filename="ioncube_loaders"

ionCube32_filename="ioncube_loaders_lin_x86"
set_md5 $ionCube32_filename "bd1b53ea61df2641b2632261646fd81b"
set_dl $ionCube32_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ioncube_loaders_lin_x86.tar.gz
http://dl-us.centos.bz/ezhttp/ioncube_loaders_lin_x86.tar.gz
http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz
'

ionCube64_filename="ioncube_loaders_lin_x86-64"
set_md5 $ionCube64_filename "49851554b1e448142b8576e399ae3b19"
set_dl $ionCube64_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ioncube_loaders_lin_x86-64.tar.gz
http://dl-us.centos.bz/ezhttp/ioncube_loaders_lin_x86-64.tar.gz
http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
'

#ZendGuardLoader设置
ZendGuardLoader_filename="ZendGuardLoader"

ZendGuardLoader53_32_filename="ZendGuardLoader-php-5.3-linux-glibc23-i386"
set_md5 $ZendGuardLoader53_32_filename "f53e51ecb59e390be5551ff7cc8576b0"
set_dl $ZendGuardLoader53_32_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
http://dl-us.centos.bz/ezhttp/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
'

ZendGuardLoader54_32_filename="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386"
set_md5 $ZendGuardLoader54_32_filename "9a25ff3c2fa4cb37602ba6d6491e859e"
set_dl $ZendGuardLoader54_32_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
http://dl-us.centos.bz/ezhttp/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
'

ZendGuardLoader53_64_filename="ZendGuardLoader-php-5.3-linux-glibc23-x86_64"
set_md5 $ZendGuardLoader53_64_filename "9408297e9e38d5ce2cca92c619b5ad50"
set_dl $ZendGuardLoader53_64_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
http://dl-us.centos.bz/ezhttp/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
'

ZendGuardLoader54_64_filename="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64"
set_md5 $ZendGuardLoader54_64_filename "09d0da0046eb70c3d704db1e0074098e"
set_dl $ZendGuardLoader54_64_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
http://dl-us.centos.bz/ezhttp/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
'

#xdebug设置
xdebug_filename="xdebug-XDEBUG_2_2_2"
set_md5 $xdebug_filename "93e68e45de087909092a979d3922c0cf"
set_dl $xdebug_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/xdebug-XDEBUG_2_2_2.tar.gz
http://dl-us.centos.bz/ezhttp/xdebug-XDEBUG_2_2_2.tar.gz
https://github.com/derickr/xdebug/archive/XDEBUG_2_2_2.tar.gz
'
set_hint $xdebug_filename "xdebug-2.2.2"

#memcached设置
memcached_filename="memcached-1.4.24"
set_md5 $memcached_filename "4d6e8c90e2068580526c7579dd7f37f6"
set_dl $memcached_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/memcached-1.4.24.tar.gz
http://dl-us.centos.bz/ezhttp/memcached-1.4.24.tar.gz
http://www.memcached.org/files/memcached-1.4.24.tar.gz
'

#redis设置
redis_filename="redis-3.0.3"
set_md5 $redis_filename "76725490d6168cfb4b0ce014b89d4b54"
set_dl $redis_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/redis-3.0.3.tar.gz
http://dl-us.centos.bz/ezhttp/redis-3.0.3.tar.gz
http://download.redis.io/releases/redis-3.0.3.tar.gz
'

#phpMyAdmin设置
phpMyAdmin_filename="phpMyAdmin-4.4.12-all-languages"
set_md5 $phpMyAdmin_filename "37b4fb4ff8681ef8191d03089f21d3fc"
set_dl $phpMyAdmin_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/phpMyAdmin-4.4.12-all-languages.tar.gz
http://dl-us.centos.bz/ezhttp/phpMyAdmin-4.4.12-all-languages.tar.gz
https://files.phpmyadmin.net/phpMyAdmin/4.4.12/phpMyAdmin-4.4.12-all-languages.tar.gz
'

#phpRedisAdmin设置
phpRedisAdmin_filename="phpRedisAdmin-1.1.0"
set_md5 $phpRedisAdmin_filename "ec34a4c966eaa8fb461e50d76eec1e8d"
set_dl $phpRedisAdmin_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/phpRedisAdmin-1.1.0.tar.gz
http://dl-us.centos.bz/ezhttp/phpRedisAdmin-1.1.0.tar.gz
https://github.com/ErikDubbelboer/phpRedisAdmin/archive/v1.1.0.tar.gz
'

#Predis设置(phpRedisAdmin依赖)
Predis_filename="predis-1.0.1"
set_md5 $Predis_filename "91ea74ee8bb336417cdf139e708fcf43"
set_dl $Predis_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/predis-1.0.1.tar.gz
http://dl-us.centos.bz/ezhttp/predis-1.0.1.tar.gz
https://github.com/nrk/predis/archive/v1.0.1.tar.gz
'

#memadmin设置
memadmin_filename="memadmin-1.0.12"
set_md5 $memadmin_filename "32ee5b051884cad350b450d30e537909"
set_dl $memadmin_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/memadmin-1.0.12.tar.gz
http://dl-us.centos.bz/ezhttp/memadmin-1.0.12.tar.gz
https://github.com/junstor/memadmin/archive/v1.0.12.tar.gz
'

#rockmongo设置
rockmongo_filename="rockmongo-1.1.6-fix-auth"
set_md5 $rockmongo_filename "80cbe1f3e022cb1290b67cb042c5a97f"
set_dl $rockmongo_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/rockmongo-fix-auth.zip
http://dl-us.centos.bz/ezhttp/rockmongo-fix-auth.zip
https://github.com/centos-bz/rockmongo/archive/fix-auth.zip
'

#PureFTPd设置
PureFTPd_filename="pure-ftpd-1.0.41"
set_md5 $PureFTPd_filename "28a0d0a9384f9e9be289febc7f4b8244"
set_dl $PureFTPd_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/pure-ftpd-1.0.41.tar.gz
http://dl-us.centos.bz/ezhttp/pure-ftpd-1.0.41.tar.gz
http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.41.tar.gz
'

#user_manager_pureftpd设置
user_manager_pureftpd_filename="ftp_v2.1"
set_md5 $user_manager_pureftpd_filename "37982c47185e009f7dc54b29ddd7d5fa"
set_dl $user_manager_pureftpd_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ftp_v2.1.tar.gz
http://dl-us.centos.bz/ezhttp/ftp_v2.1.tar.gz
http://machiel.generaal.net/files/pureftpd/ftp_v2.1.tar.gz
'

#mongodb设置
mongodb32_filename="mongodb-linux-i686-2.4.9"
set_md5 $mongodb32_filename "33d4707a4dcb5c32b9c8a3be008d0580"
set_dl $mongodb32_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/mongodb-linux-i686-2.4.9.tgz
http://dl-us.centos.bz/ezhttp/mongodb-linux-i686-2.4.9.tgz
http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.4.9.tgz
'

mongodb64_filename="mongodb-linux-x86_64-2.4.9"
set_md5 $mongodb64_filename "8a82a96d09242e859e225e226e7f47fc"
set_dl $mongodb64_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/mongodb-linux-x86_64-2.4.9.tgz
http://dl-us.centos.bz/ezhttp/mongodb-linux-x86_64-2.4.9.tgz
http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.9.tgz
'

mongodbLegacy64_filename="mongodb-linux-x86_64-legacy-2.4.8"
set_md5 $mongodbLegacy64_filename "6d528120e4749d5508b066177f37de11"
set_dl $mongodbLegacy64_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/mongodb-linux-x86_64-legacy-2.4.8.tgz
http://dl-us.centos.bz/ezhttp/mongodb-linux-x86_64-legacy-2.4.8.tgz
http://downloads.mongodb.org/linux/mongodb-linux-x86_64-legacy-2.4.8.tgz
'

#根据glibc和系统位数选择mongodb版本
local v1=`ldd --version | awk 'NR==1{print $NF}' | awk -F'.' '{print $1}'`
local v2=`ldd --version | awk 'NR==1{print $NF}' | awk -F'.' '{print $2}'`

if [[ $v1 -eq 2 ]]; then
    if [[ $v2 -ge 5 ]];then
        if is_64bit;then
            mongodb_filename="$mongodb64_filename"
        else
            mongodb_filename="$mongodb32_filename"      
        fi          
    else
        if is_64bit;then
            mongodb_filename="$mongodbLegacy64_filename"
        fi
    fi

elif [[ $v1 -gt 2 ]]; then
    if is_64bit;then
        mongodb_filename="$mongodb64_filename"
    else
        mongodb_filename="$mongodb32_filename"      
    fi  
fi      

set_md5 $mongodb_filename $(get_md5 $mongodb_filename)
set_dl $mongodb_filename "$(get_dl $mongodb_filename)"

######################依赖包设置######################

#cmake设置
cmake_filename="cmake-3.12.2"
set_md5 $cmake_filename "6e7c550cfa1c2e216b35903dc70d80af"
set_dl $cmake_filename '
https://github.com/Kitware/CMake/releases/download/v3.12.2/cmake-3.12.2.tar.gz
https://cmake.org/files/v3.12/cmake-3.12.2.tar.gz
'

#ncurses设置(保持5.8版本)
ncurses_filename="ncurses-5.8"
set_md5 $ncurses_filename "20ed3fa7599937f0ca268d9088837a64"
set_dl $ncurses_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ncurses-5.8.tar.gz
http://dl-us.centos.bz/ezhttp/ncurses-5.8.tar.gz
http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.8.tar.gz
http://mirrors.ustc.edu.cn/gnu/ncurses/ncurses-5.8.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/gnu/ncurses/ncurses-5.8.tar.gz
'

#ncurses设置(保持5.5版本,用于mysql5.1的安装)
ncurses_filename2="ncurses-5.5"
set_md5 $ncurses_filename2 "e73c1ac10b4bfc46db43b2ddfd6244ef"
set_dl $ncurses_filename2 '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ncurses-5.5.tar.gz
http://dl-us.centos.bz/ezhttp/ncurses-5.5.tar.gz
http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.5.tar.gz
http://mirrors.ustc.edu.cn/gnu/ncurses/ncurses/ncurses-5.5.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/ncurses/ncurses-5.5.tar.gz
'

#bison设置
bison_filename="bison-2.7"
set_md5 $bison_filename "ded660799e76fb1667d594de1f7a0da9"
set_dl $bison_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/bison-2.7.tar.gz
http://dl-us.centos.bz/ezhttp/bison-2.7.tar.gz
http://ftp.gnu.org/gnu/bison/bison-2.7.tar.gz
http://mirrors.ustc.edu.cn/gnu/bison/bison-2.7.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/bison-2.7.tar.gz

'

#patch设置
patch_filename="patch-2.7"
set_md5 $patch_filename "1cbaa223ff4991be9fae8ec1d11fb5ab"
set_dl $patch_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/patch-2.7.tar.gz
http://dl-us.centos.bz/ezhttp/patch-2.7.tar.gz
http://ftp.gnu.org/gnu/patch/patch-2.7.tar.gz
http://mirrors.ustc.edu.cn/gnu/patch/patch-2.7.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/gnu/patch/patch-2.7.tar.gz
'

#libiconv设置
libiconv_filename="libiconv-1.14"
set_md5 $libiconv_filename "e34509b1623cec449dfeb73d7ce9c6c6"
set_dl $libiconv_filename '
http://dl-us.centos.bz/ezhttp/libiconv-1.14.tar.gz
http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
http://mirrors.ustc.edu.cn/gnu/libiconv/libiconv-1.14.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/gnu/libiconv/libiconv-1.14.tar.gz
'


#autoconf设置(保持2.69版本)
autoconf_filename="autoconf-2.69"
set_md5 $autoconf_filename "82d05e03b93e45f5a39b828dc9c6c29b"
set_dl $autoconf_filename '
http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
http://mirrors.ustc.edu.cn/gnu/autoconf/autoconf-2.69.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/gnu/autoconf/autoconf-2.69.tar.gz
'

#libxml2设置(保持2-2.8.0版本)
libxml2_filename="libxml2-2.8.0"
set_md5 $libxml2_filename "c62106f02ee00b6437f0fb9d370c1093"
set_dl $libxml2_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/libxml2-2.8.0.tar.gz
http://dl-us.centos.bz/ezhttp/libxml2-2.8.0.tar.gz
ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
'

#openssl设置 
openssl_filename="openssl-1.0.2h"
set_md5 $openssl_filename "9392e65072ce4b614c1392eefc1f23d0"
set_dl $openssl_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/openssl-1.0.2h.tar.gz
http://dl-us.centos.bz/ezhttp/openssl-1.0.2h.tar.gz
http://www.openssl.org/source/openssl-1.0.2h.tar.gz
'

#zlib设置
zlib_filename="zlib-1.2.8"
set_md5 $zlib_filename "44d667c142d7cda120332623eab69f40"
set_dl $zlib_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/zlib-1.2.8.tar.gz
http://dl-us.centos.bz/ezhttp/zlib-1.2.8.tar.gz
http://zlib.net/zlib-1.2.8.tar.gz
'

#libcurl设置
libcurl_filename="curl-7.30.0"
set_md5 $libcurl_filename "60bb6ff558415b73ba2f00163fd307c5"
set_dl $libcurl_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/curl-7.30.0.tar.gz
http://dl-us.centos.bz/ezhttp/curl-7.30.0.tar.gz
http://curl.haxx.se/download/curl-7.30.0.tar.gz
'

#pcre设置
pcre_filename="pcre-8.33"
set_md5 $pcre_filename "94854c93dcc881edd37904bb6ef49ebc"
set_dl $pcre_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/pcre-8.33.tar.gz
http://dl-us.centos.bz/ezhttp/pcre-8.33.tar.gz
http://jaist.dl.sourceforge.net/project/pcre/pcre/8.33/pcre-8.33.tar.gz
'

#libtool设置
libtool_filename="libtool-2.4"
set_md5 $libtool_filename "b32b04148ecdd7344abc6fe8bd1bb021"
set_dl $libtool_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/libtool-2.4.tar.gz
http://dl-us.centos.bz/ezhttp/libtool-2.4.tar.gz
http://mirrors.kernel.org/gnu/libtool/libtool-2.4.tar.gz
'

#libjpeg设置
libjpeg_filename="jpeg-6b"
set_md5 $libjpeg_filename "dbd5f3b47ed13132f04c685d608a7547"
set_dl $libjpeg_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/jpegsrc.v6b.tar.gz
http://dl-us.centos.bz/ezhttp/jpegsrc.v6b.tar.gz
http://jaist.dl.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz
'

#freetype设置
freetype_filename="freetype-2.8.1"
set_md5 $freetype_filename "c947b6b1c513e814cc9d7617a44bc6cf"
set_dl $freetype_filename '
https://jaist.dl.sourceforge.net/project/freetype/freetype2/2.8.1/freetype-2.8.1.tar.gz
https://nchc.dl.sourceforge.net/project/freetype/freetype2/2.8.1/freetype-2.8.1.tar.gz
http://download.savannah.gnu.org/releases/freetype/freetype-2.8.1.tar.gz
'

#libpng设置(不要更新,防止出现undefined reference to inflateReset2@ZLIB_1.2.3.4)
libpng_filename="libpng-1.4.19"
set_md5 $libpng_filename "89bcbc4fc8b31f4a403906cf4f662330"
set_dl $libpng_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/libpng-1.4.19.tar.gz
http://dl-us.centos.bz/ezhttp/libpng-1.4.19.tar.gz
http://jaist.dl.sourceforge.net/project/libpng/libpng14/1.4.19/libpng-1.4.19.tar.gz
'

#mhash设置
mhash_filename="mhash-0.9.9.9"
set_md5 $mhash_filename "ee66b7d5947deb760aeff3f028e27d25"
set_dl $mhash_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/mhash-0.9.9.9.tar.gz
http://dl-us.centos.bz/ezhttp/mhash-0.9.9.9.tar.gz
http://jaist.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz
'

#libmcrypt设置
libmcrypt_filename="libmcrypt-2.5.8"
set_md5 $libmcrypt_filename "0821830d930a86a5c69110837c55b7da"
set_dl $libmcrypt_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/libmcrypt-2.5.8.tar.gz
http://dl-us.centos.bz/ezhttp/libmcrypt-2.5.8.tar.gz
http://jaist.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
'

#m4设置
m4_filename="m4-1.4.16"
set_md5 $m4_filename "a5dfb4f2b7370e9d34293d23fd09b280"
set_dl $m4_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/m4-1.4.16.tar.gz
http://dl-us.centos.bz/ezhttp/m4-1.4.16.tar.gz
http://ftp.gnu.org/gnu/m4/m4-1.4.16.tar.gz
'

#libevent设置
libevent_filename="libevent-2.0.21-stable"
set_md5 $libevent_filename "b2405cc9ebf264aa47ff615d9de527a2"
set_dl $libevent_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/libevent-2.0.21-stable.tar.gz
http://dl-us.centos.bz/ezhttp/libevent-2.0.21-stable.tar.gz
http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
'

#apr设置
apr_filename="apr-1.5.2"
set_md5 $apr_filename "98492e965963f852ab29f9e61b2ad700"
set_dl $apr_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/apr-1.5.2.tar.gz
http://dl-us.centos.bz/ezhttp/apr-1.5.2.tar.gz
http://apache.cs.utah.edu/apr/apr-1.5.2.tar.gz
'

#apr-util设置
apr_util_filename="apr-util-1.5.4"
set_md5 $apr_util_filename "866825c04da827c6e5f53daff5569f42"
set_dl $apr_util_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/apr-util-1.5.4.tar.gz
http://dl-us.centos.bz/ezhttp/apr-util-1.5.4.tar.gz
http://apache.cs.utah.edu//apr/apr-util-1.5.4.tar.gz
'

#jailkit设置
jailkit_filename="jailkit-2.17"
set_md5 $jailkit_filename "7b5a68abe89a65e0e29458cc1fd9ad0b"
set_dl $jailkit_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/jailkit-2.17.tar.gz
http://dl-us.centos.bz/ezhttp/jailkit-2.17.tar.gz
http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz
'

# jdk7设置
if is_64bit;then
    jdk7_64_filename="jdk1.7.0_79"
    set_md5 $jdk7_64_filename "9222e097e624800fdd9bfb568169ccad"
    set_dl $jdk7_64_filename '
    http://dl-cn.centos.bz/protect/10268950/ezhttp/jdk-7u79-linux-x64.tar.gz
    http://dl-us.centos.bz/ezhttp/jdk-7u79-linux-x64.tar.gz
    http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
    '
    jdk7_filename=$jdk7_64_filename
else
    jdk7_32_filename="jdk1.7.0_79"
    set_md5 $jdk7_32_filename "b0ed59147c77a6d3e63a7b340e4e1d28"
    set_dl $jdk7_32_filename '
    http://dl-cn.centos.bz/protect/10268950/ezhttp/jdk-7u79-linux-i586.tar.gz
    http://dl-us.centos.bz/ezhttp/jdk-7u79-linux-i586.tar.gz
    http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-i586.tar.gz
    '
    jdk7_filename=$jdk7_32_filename
fi

# jdk8设置
if is_64bit;then
    jdk8_64_filename="jdk1.8.0_66"
    set_md5 $jdk8_64_filename "88f31f3d642c3287134297b8c10e61bf"
    set_dl $jdk8_64_filename '
    http://dl-cn.centos.bz/protect/10268950/ezhttp/jdk-8u66-linux-x64.tar.gz
    http://dl-us.centos.bz/ezhttp/jdk-8u66-linux-x64.tar.gz
    http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz
    '
    jdk8_filename=$jdk8_64_filename
else
    jdk8_32_filename="jdk1.8.0_66"
    set_md5 $jdk8_32_filename "8a1f36b29152856a5dd2c3953a4c24a1"
    set_dl $jdk8_32_filename '
    http://dl-cn.centos.bz/protect/10268950/ezhttp/jdk-8u66-linux-i586.tar.gz
    http://dl-us.centos.bz/ezhttp/jdk-8u66-linux-i586.tar.gz
    http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-i586.tar.gz
    '
    jdk8_filename=$jdk8_32_filename
fi

# tomcat7设置
tomcat7_filename="apache-tomcat-7.0.68"
set_md5 $tomcat7_filename "94688679d5f37499d1bd1a65eb9540e7"
set_dl $tomcat7_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/apache-tomcat-7.0.68.tar.gz
http://dl-us.centos.bz/ezhttp/apache-tomcat-7.0.68.tar.gz
http://mirror.symnds.com/software/Apache/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz
'

# tomcat8设置
tomcat8_filename="apache-tomcat-8.0.39"
set_md5 $tomcat8_filename "529c26b1987e2bd5e04785ef7c814271"
set_dl $tomcat8_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/apache-tomcat-8.0.39.tar.gz
http://dl-us.centos.bz/ezhttp/apache-tomcat-8.0.39.tar.gz
http://ftp.wayne.edu/apache/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz
'
# php-memcached设置
php_memcached_filename="memcached-2.2.0"
set_md5 $php_memcached_filename "28937c6144f734e000c6300242f44ce6"
set_dl $php_memcached_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/memcached-2.2.0.tgz
http://dl-us.centos.bz/ezhttp/memcached-2.2.0.tgz
https://pecl.php.net/get/memcached-2.2.0.tgz
'
set_hint $php_memcached_filename "php-memcached-2.2.0 (Support Aliyun OCS)"

# libmemcached设置
libmemcached_filename="libmemcached-1.0.18"
set_md5 $libmemcached_filename "b3958716b4e53ddc5992e6c49d97e819"
set_dl $libmemcached_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/libmemcached-1.0.18.tar.gz
http://dl-us.centos.bz/ezhttp/libmemcached-1.0.18.tar.gz
https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
'
# nginx lua module设置
lua_nginx_module_filename="lua-nginx-module-0.10.7"
set_md5 $lua_nginx_module_filename "6eb0161f495bb996af6bbb58f3cef764"
set_dl $lua_nginx_module_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/lua-nginx-module-0.10.7.tar.gz
http://dl-us.centos.bz/ezhttp/lua-nginx-module-0.10.7.tar.gz
https://github.com/openresty/lua-nginx-module/archive/v0.10.7.tar.gz
'

# luajit设置
luajit_filename="LuaJIT-2.0.4"
set_md5 $luajit_filename "dd9c38307f2223a504cbfb96e477eca0"
set_dl $luajit_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/LuaJIT-2.0.4.tar.gz
http://dl-us.centos.bz/ezhttp/LuaJIT-2.0.4.tar.gz
http://luajit.org/download/LuaJIT-2.0.4.tar.gz
'

# ngx_devel_kit设置
ngx_devel_kit_filename="ngx_devel_kit-0.2.19"
set_md5 $ngx_devel_kit_filename "09a18178adca7b5674129d8100ce4f68"
set_dl $ngx_devel_kit_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ngx_devel_kit-0.2.19.tar.gz
http://dl-us.centos.bz/ezhttp/ngx_devel_kit-0.2.19.tar.gz
https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz
'

# nginx-http-concat module设置
nginx_concat_module_filename="nginx-http-concat-1.2.2"
set_md5 $nginx_concat_module_filename "490d9705b7461e4c58cf28bd7fee3040"
set_dl $nginx_concat_module_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/nginx-http-concat-1.2.2.tar.gz
http://dl-us.centos.bz/ezhttp/nginx-http-concat-1.2.2.tar.gz
https://github.com/alibaba/nginx-http-concat/archive/1.2.2.tar.gz
'

# nginx-upload-module-2.2设置
nginx_upload_module_filename="nginx-upload-module-2.2"
set_md5 $nginx_upload_module_filename "ad52deb7a5b2ca7a5351ebac92a531df"
set_dl $nginx_upload_module_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/nginx-upload-module-2.2.zip
http://dl-us.centos.bz/ezhttp/nginx-upload-module-2.2.zip
https://codeload.github.com/vkholodkov/nginx-upload-module/zip/2.2
'

# ngx_http_substitutions_filter_module设置
ngx_substitutions_filter_module_filename="ngx_http_substitutions_filter_module-0.6.4"
set_md5 $ngx_substitutions_filter_module_filename "bc4482c8f9a10a59d14e46693b87e00c"
set_dl $ngx_substitutions_filter_module_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/ngx_http_substitutions_filter_module-0.6.4.tar.gz
http://dl-us.centos.bz/ezhttp/ngx_http_substitutions_filter_module-0.6.4.tar.gz
https://codeload.github.com/yaoweibin/ngx_http_substitutions_filter_module/tar.gz/v0.6.4
'

# nginx_upstream_check_module设置
nginx_upstream_check_module_filename="nginx_upstream_check_module-master"
set_md5 $nginx_upstream_check_module_filename "ee9f11257dd54b9f239f29b5189fe450"
set_dl $nginx_upstream_check_module_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/nginx_upstream_check_module-master.zip
http://dl-us.centos.bz/ezhttp/nginx_upstream_check_module-master.zip
https://codeload.github.com/yaoweibin/nginx_upstream_check_module/zip/master
'

# nginx-stream-upsync-module设置
nginx_stream_upsync_module_filename="nginx-stream-upsync-module-master"
set_md5 $nginx_stream_upsync_module_filename "e9350a7d2a468b353c321adaf9aa5fec"
set_dl $nginx_stream_upsync_module_filename '
http://dl-cn.centos.bz/protect/10268950/ezhttp/nginx-stream-upsync-module-master.zip
http://dl-us.centos.bz/ezhttp/nginx-stream-upsync-module-master.zip
https://codeload.github.com/xiaokai-wang/nginx-stream-upsync-module/zip/master
'

########################其它设置########################

#nginx apache mysql php等软件菜单设置
nginx_arr=( ${nginx_filename} ${tengine_filename} ${openresty_filename} custom_version do_not_install)
nginx_modules_arr=(${lua_nginx_module_filename} ${nginx_concat_module_filename} ${nginx_upload_module_filename} 
            ${ngx_substitutions_filter_module_filename} ngx_stream_core_module ${nginx_upstream_check_module_filename} ${nginx_stream_upsync_module_filename} do_not_install)
apache_arr=( ${apache2_2_filename} ${apache2_4_filename} custom_version do_not_install)
mysql_arr=( ${mysql5_1_filename} ${mysql5_5_filename} ${mysql5_6_filename} ${mysql5_7_filename} ${mysql8_0_filename} libmysqlclient18 custom_version do_not_install)
php_arr=( ${php5_2_filename} ${php5_3_filename} ${php5_4_filename} ${php5_5_filename} ${php5_6_filename} ${php7_1_filename} ${php7_2_filename} ${php7_3_filename} custom_version do_not_install)
php_mode_arr=(with_apache  with_fastcgi)
php_modules_arr=( ${ZendOptimizer_filename} ${ZendGuardLoader_filename} ${xcache_filename} ${eaccelerator_filename}
                 ${php_imagemagick_filename} ${ionCube_filename} ${php_memcache_filename} ${php_memcached_filename} ${php_redis_filename} 
                 ${php_mongo_filename}  ${xdebug_filename} mssql fileinfo php-gmp $swoole_filename do_not_install)
other_soft_arr=( ${memcached_filename} ${PureFTPd_filename} ${phpMyAdmin_filename} ${redis_filename} 
                ${mongodb_filename} ${phpRedisAdmin_filename} ${memadmin_filename} ${rockmongo_filename} ${jdk7_filename} 
                ${jdk8_filename} ${tomcat7_filename} ${tomcat8_filename} do_not_install)

#工具菜单设置
tools_arr=(System_swap_settings Generate_mysql_my_cnf Create_rpm_package Percona_xtrabackup_install Change_sshd_port 
            Iptables_settings Enable_disable_php_extension Set_timezone_and_sync_time Initialize_mysql_server Add_chroot_shell_user 
            Network_analysis Configure_apt_yum_repository Install_rsync_server Backup_setup Count_process_file_access Install_dotnet_core 
            Install_docker Install_docker_compose Deploy_shadowsocks Install_jexus Back_to_main_menu)

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
