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

# 载入函数
load_functions(){
	local function=$1

	if [[ -s $cur_dir/function/${function}.sh ]];then
		. $cur_dir/function/${function}.sh
	else
		echo "$cur_dir/function/${function}.sh not found,shell can not be executed."
		exit 1
	fi	
}

# 初始化
init(){
    #开始载入
    load_functions config
    load_functions public
    load_functions apache
    load_functions depends
    load_functions mysql
    load_functions nginx
    load_functions other-soft
    load_functions php
    load_functions php-modules
    load_functions tools
    load_functions other
    load_functions upgrade

    #创建记录安装路径信息文件
    touch /etc/ezhttp_info_do_not_del
    #不允许删除，只允许追加
    chattr +a /etc/ezhttp_info_do_not_del
    need_root_priv
    load_config
}

help(){
    cat <<EOF
Usage: ./start --stack=NAME --package=PACKAGE1[,PACKAGE2] [options]
  -h, --help                        This usage guide
  --stack=lnmp/lamp/lnamp           Specify a stack from lnmp lamp and lnamp
  --package=PACKAGE1[,PACKAGE2]     Choose what package you'll install,multiple packages separated by commas,available packages:
                                    [http server]
                                    nginx,tengine,openresty,apache2.2,apache2.4,tomcat7,tomcat8

                                    [database server]
                                    mysql5.1,mysql5.5,mysql5.6,mysql5.7

                                    [language environment]
                                    php5.2,php5.3,php5.4,php5.5,php5.6,php7.0,jdk7,jdk8

                                    [nosql server]
                                    memcached,mongodb,redis

                                    [ftp server]
                                    pureftpd

                                    [web admin]
                                    phpmyadmin,phpredisadmin,memadmin,rockmongo
  --skip                            Skip check if the path exists                                  
  --nginx-prefix=PATH               Nginx installation path,default /usr/local/nginx
  --nginx-module=NAME1[,NAME2]      Add extra modules to nginx core,available modules:
                                    lua-nginx-module,nginx-http-concat,nginx-upload-module,ngx_http_substitutions_filter_module
  --apache-prefix=PATH              Apache installation path,default /usr/local/apache
  --tomcat-prefix=PATH              Tomcat installation path,default /usr/local/tomcat[7/8]
  --mysql-prefix=PATH               Mysql installation path,default /usr/local/mysql
  --mysql-data=PATH                 Mysql data path,default /usr/local/mysql/data 
  --mysql-root-pwd=PASSWORD         Mysql root password,default root 
  --mysql-port=PORT                 Mysql port number,default 3306
  --php-prefix=PATH                 PHP installation path,default /usr/local/php
  --php-module=NAME1[,NAME2]        Add extra php modules support,available modules:
                                    ZendOptimizer,ZendGuardLoader,xcache,eaccelerator,php_imagemagick,ionCube,php_memcache,
                                    php_memcached,php_redis,php_mongo,xdebug,mssql,fileinfo,php-gmp,swoole

                                    Attention: some modules may not be supported in some conditions.such as ZendOptimizer only support php5.2
                                    you can list supported modules with options --list-php-modules=php5.2/php5.3 ...
  --list-php-modules=PHP-VERSION    List the supported  modules for the php version, php version available:
                                    php5.2,php5.3,php5.4,php5.5,php5.6,php7.0
  --jdk-prefix=PATH                 Jdk installation path,default /usr/local/jdk[7/8]
  --memcached-prefix=PATH           Memcached installation path,default /usr/local/memcached
  --mongodb-prefix=PATH             Mongodb installation path,default /usr/local/mongodb 
  --mongodb-data=PATH               Mongodb data path,default /usr/local/mongodb/data 
  --redis-prefix=PATH               Redis installation path,default /usr/local/redis
  --redis-maxmem=NUMBER OF BYTE     Redis max memory allow,default half of system memory 
  --pureftpd-prefix=PATH            Pureftpd installation path,default /usr/local/pureftpd
  --phpmyadmin-prefix=PATH          Phpmyadmin installation path,default /home/wwwroot/phpmyadmin 
  --phpredisadmin-prefix=PATH       Phpredisadmin installation path,default /home/wwwroot/phpredisadmin 
  --memadmin-prefix=PATH            Memadmin installation path,default /home/wwwroot/memadmin
  --rockmongo-prefix=PATH           Rockmongo installation path,default /home/wwwroot/rockmongo

EOF

}

list_php_modules(){
    local version=$1
    local php_modules=(ZendOptimizer ZendGuardLoader xcache eaccelerator php_imagemagick ionCube php_memcache php_memcached php_redis php_mongo xdebug mssql fileinfo php-gmp swoole)
    if [ "$version" == "5.2" ];then
        #因为ZendGuardLoader不支持php5_2，所以从数组中删除
        php_modules=(${php_modules[@]#ZendGuardLoader})
    elif [ "$version" == "5.3" ];then
        #因为ZendOptimizer不支持php5_3,所以从数组中删除
        php_modules=(${php_modules[@]#ZendOptimizer})
    elif [ "$version" == "5.4" ];then
        #从数组中删除ZendOptimizer、eaccelerator
        php_modules=(${php_modules[@]#ZendOptimizer})
        php_modules=(${php_modules[@]#eaccelerator})
    elif [ "$version" == "5.5" ];then
        #从数组中删除ZendOptimizer、eaccelerator、xcache ionCube_filename
        php_modules=(${php_modules[@]#ZendOptimizer})
        php_modules=(${php_modules[@]#eaccelerator})
        php_modules=(${php_modules[@]#xcache})
        php_modules=(${php_modules[@]#ZendGuardLoader})
        php_modules=(${php_modules[@]#ionCube})
    elif [ "$version" == "5.6" ];then
        #从数组中删除ZendOptimizer、eaccelerator、xcache ionCube_filename
        php_modules=(${php_modules[@]#ZendOptimizer})
        php_modules=(${php_modules[@]#eaccelerator})
        php_modules=(${php_modules[@]#xcache})
        php_modules=(${php_modules[@]#ZendGuardLoader})
        php_modules=(${php_modules[@]#ionCube})
    elif [ "$version" == "7.0" ];then
        #从数组中删除ZendOptimizer、eaccelerator、xcache ionCube_filename
        php_modules=(${php_modules[@]#ZendOptimizer})
        php_modules=(${php_modules[@]#eaccelerator})
        php_modules=(${php_modules[@]#xcache})
        php_modules=(${php_modules[@]#ZendGuardLoader})
        php_modules=(${php_modules[@]#ionCube})
        php_modules=(${php_modules[@]#php_imagemagick})
        php_modules=(${php_modules[@]#php_memcached})
        php_modules=(${php_modules[@]#php_memcache})
        php_modules=(${php_modules[@]#php_redis})
        php_modules=(${php_modules[@]#php_mongo})
        php_modules=(${php_modules[@]#xdebug})
        php_modules=(${php_modules[@]#mssql})
    else
        echo "error,php version $version invalid,valid versions are 5.2 5.3 5.4 5.5 5.6 7.0"
        exit 1
    fi

    for m in ${php_modules[@]};do
        echo "$m"
    done    
}

setup_by_menu(){
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
    pre_setting    
}

setup_by_cmdline(){
    if [[ "$stack" == "" ]]; then
        echo "error,--stack option is not set"
        exit 1
    fi

    if [[ ! "$stack" =~ lnmp|lamp|lnamp ]]; then
        echo "error,--stack option value $stack is invalid,please choose one from lnmp,lamp,lnamp."
        exit 1
    fi

    if [[ "$package" == "" ]]; then
        echo "error,--package option is not set"
        exit 1
    fi

    # 检查package值
    package_valid=true
    package=$(echo "$package" | tr ',' ' ')
    for p in $package;do
        if ! if_in_array "$p" "$AVAILABLE_PACKAGES";then
            echo "package $p invalid."
            package_valid=false
        fi    
    done
    if ! $package_valid;then exit 1;fi

    # 设置nginx
    if [[ "$stack" =~ lnmp|lnamp ]]; then
        # 检查路径
        if if_in_array nginx "$package" || if_in_array tengine "$package" || if_in_array openresty "$package";then
            if_in_array openresty "$package" && nginx_default=/usr/local/openresty || nginx_default=/usr/local/nginx

            nginx_default=/usr/local/nginx
            nginx_location=${nginx_location:=$nginx_default}
            if path_valid "$nginx_location";then
                echo "--nginx-prefix=$nginx_location is invalid"
                exit 1
            fi
            
            if [[ $skip == false && -a "$nginx_location" ]]; then
                echo "--nginx-prefix=$nginx_location exists,please input other path or add --skip to disable path checking."
                exit 1
            fi
        fi

        # 设置编译参数
        if if_in_array nginx "$package";then
            nginx=${nginx_filename}
            nginx_configure_args="--prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename}  --with-http_sub_module --with-http_stub_status_module --with-pcre-jit --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_v2_module"

        elif if_in_array tengine "$package";then
            nginx=${tengine_filename}
            nginx_configure_args="--prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre-jit --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_concat_module --with-http_sysguard_module --with-http_upstream_check_module --with-http_v2_module"

        elif if_in_array openresty "$package";then
            nginx=${openresty_filename}
            nginx_configure_args="--prefix=${nginx_location} --with-luajit --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre-jit --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_v2_module"

        else
            nginx=do_not_install
        fi
    
        #检测模块
        if [[ "$nginx_modules_install" != "" ]]; then
            nginx_modules_valid=true
            nginx_modules_install=$(echo "$nginx_modules_install" | tr ',' ' ')
            for m in $nginx_modules_install;do
                if ! if_in_array "$m" "$AVAILABLE_NGINX_MODULES";then
                    echo "nginx module $m invalid."
                    nginx_modules_valid=false
                fi    
            done
            if ! $nginx_modules_valid;then exit 1;fi       

            tmp=""
            if if_in_array lua-nginx-module "$nginx_modules_install";then
                if ! if_in_array openresty "$package";then
                    tmp="$tmp ${lua_nginx_module_filename}"
                fi    
            fi    

            if if_in_array nginx-http-concat "$nginx_modules_install";then
                if ! if_in_array tengine "$package";then
                    tmp="$tmp ${nginx_concat_module_filename}"
                fi                
                
            fi 

            if if_in_array nginx-upload-module "$nginx_modules_install";then
                tmp="$tmp ${nginx_upload_module_filename}"
            fi 

            if if_in_array ngx_http_substitutions_filter_module "$nginx_modules_install";then
                tmp="$tmp ${ngx_substitutions_filter_module_filename}"
            fi

            nginx_modules_install="$tmp"

            #设置编译参数
            if if_in_array "${lua_nginx_module_filename}" "$nginx_modules_install";then
                nginx_configure_args="${nginx_configure_args} --with-ld-opt='-Wl,-rpath,${depends_prefix}/${luajit_filename}' --add-module=$cur_dir/soft/${ngx_devel_kit_filename} --add-module=$cur_dir/soft/${lua_nginx_module_filename}"
            fi

            if if_in_array "${nginx_concat_module_filename}" "$nginx_modules_install";then
                nginx_configure_args="${nginx_configure_args} --add-module=$cur_dir/soft/${nginx_concat_module_filename}"
            fi

            if if_in_array "${nginx_upload_module_filename}" "$nginx_modules_install";then
                nginx_configure_args="${nginx_configure_args} --add-module=$cur_dir/soft/${nginx_upload_module_filename}"
            fi

            if if_in_array "${ngx_substitutions_filter_module_filename}" "$nginx_modules_install";then
                nginx_configure_args="${nginx_configure_args} --add-module=$cur_dir/soft/${ngx_substitutions_filter_module_filename}"
            fi

        fi

    fi

    # 设置apache
    if [[ "$stack" =~ lamp|lnamp ]]; then
        # 检查路径
        if if_in_array apache2.2 "$package" || if_in_array apache2.4 "$package";then
            apache_location=${apache_location:="/usr/local/apache"}
            if path_valid "$apache_location";then
                echo "--apache-prefix=$apache_location is invalid"
                exit 1
            fi
            
            if [[ $skip == false && -a "$apache_location" ]]; then
                echo "--apache-prefix=$apache_location exists,please input other path or add --skip to disable path checking."
                exit 1
            fi   
        fi              

        # 设置编译参数
        if if_in_array apache2.2 "$package";then
            apache=${apache2_2_filename}
            if check_sys packageSupport;then
                other_option=""
            else
                other_option="--with-z=${depends_prefix}/${zlib_filename} --with-ssl=${depends_prefix}/${openssl_filename}"
            fi  
            apache_configure_args="--prefix=${apache_location} --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared  --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support ${other_option}"

        elif if_in_array apache2.4 "$package";then
            apache=${apache2_4_filename}
            if check_sys packageSupport;then
                other_option=""
            else
                other_option="--with-z=${depends_prefix}/${zlib_filename} --with-ssl=${depends_prefix}/${openssl_filename} --with-pcre=${depends_prefix}/${pcre_filename}"
            fi  
            apache_configure_args="--prefix=${apache_location} --enable-so --enable-deflate=shared --enable-ssl=shared --enable-expires=shared  --enable-headers=shared --enable-rewrite=shared --enable-static-support  --with-included-apr $other_option"

        else
            apache=do_not_install
        fi
       
    fi

    # 设置mysql
    if if_in_array mysql5.1 "$package" ||  if_in_array mysql5.5 "$package" || if_in_array mysql5.6 "$package" || if_in_array mysql5.7 "$package";then
        # 检查路径
        mysql_location=${mysql_location:="/usr/local/mysql"}
        if path_valid "$mysql_location";then
            echo "--mysql-prefix=$mysql_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$mysql_location" ]]; then
            echo "--mysql-prefix=$mysql_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi   

        # 设置data路径
        mysql_data_location=${mysql_data_location:=$mysql_location/data}
        if path_valid "$mysql_data_location";then
            echo "--mysql-data=$mysql_data_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$mysql_data_location" ]]; then
            echo "--mysql-data=$mysql_data_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

        # 设置root密码
        mysql_root_pass=${mysql_root_pass:=root}

        # 设置port
        mysql_port_number=${mysql_port_number:=3306}
        if ! verify_port "$mysql_port_number";then
            echo "port number $mysql_port_number is invalid."
            exit 1
        fi

        # 设置编译参数
        if if_in_array mysql5.1 "$package";then
            if check_sys packageSupport;then
                other_option=""
            else
                other_option="--with-named-curses-libs=${depends_prefix}/${ncurses_filename2}/lib/libncurses.a"
            fi
            mysql=${mysql5_1_filename}
            mysql_configure_args="--prefix=${mysql_location} --sysconfdir=${mysql_location}/etc --with-unix-socket-path=${mysql_data_location}/mysql.sock --with-charset=utf8 --with-collation=utf8_general_ci --with-extra-charsets=complex --with-plugins=max --with-mysqld-ldflags=-all-static --enable-assembler $other_option"
        elif if_in_array mysql5.5 "$package";then
            if check_sys packageSupport;then
                other_option=""
            else
                other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
            fi
            mysql=${mysql5_5_filename}
            mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 $other_option"
        elif if_in_array mysql5.6 "$package";then
            if check_sys packageSupport;then
                other_option=""
            else
                other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
            fi
            mysql=${mysql5_6_filename}
            mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DENABLED_LOCAL_INFILE=1 $other_option"
        elif if_in_array mysql5.7 "$package";then
            if check_sys packageSupport;then
                other_option=""
            else
                other_option="-DCURSES_LIBRARY=${depends_prefix}/${ncurses_filename}/lib/libncurses.a  -DCURSES_INCLUDE_PATH=${depends_prefix}/${ncurses_filename}/include/"
            fi
            mysql=${mysql5_7_filename}
            mysql_configure_args="-DCMAKE_INSTALL_PREFIX=${mysql_location} -DWITH_BOOST=$cur_dir/soft/${boost_1_59_filename}  -DSYSCONFDIR=${mysql_location}/etc -DMYSQL_UNIX_ADDR=${mysql_data_location}/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 $other_option"
        fi        

    else
        mysql=do_not_install
    fi

    # 设置php
    if if_in_array php5.2 "$package" || if_in_array php5.3 "$package" || if_in_array php5.4 "$package" || if_in_array php5.5 "$package" || if_in_array php5.6 "$package" || if_in_array php7.0 "$package";then
        # 检查路径
        php_location=${php_location:="/usr/local/php"}
        if path_valid "$php_location";then
            echo "--php-prefix=$php_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$php_location" ]]; then
            echo "--php-prefix=$php_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

        # 设置php mode
        php_mode=with_apache
        if [[ "$stack" == "lnmp" ]]; then
            php_mode="with_fastcgi"
        fi

        # 设置编译参数
        with_mysql="--with-mysql=$mysql_location --with-mysqli=$mysql_location/bin/mysql_config --with-pdo-mysql=$mysql_location/bin/mysql_config"
        with_mysqlnd="--with-mysql=mysqlnd --with-mysqli=shared,mysqlnd --with-pdo-mysql=shared,mysqlnd"
        is_64bit && lib64="--with-libdir=lib64" || lib64="" 

        if if_in_array php5.2 "$package";then

            #判断php运行模式
            if [ "$php_mode" == "with_apache" ];then
                php_run_php_mode="--with-apxs2=${apache_location}/bin/apxs"
            elif [ "$php_mode" == "with_fastcgi" ];then
                php_run_php_mode="--enable-fastcgi --enable-fpm"
            fi
            
            #判断是否支持apt或者yum安装依赖
            if check_sys packageSupport;then
                #centos 7没有mhash和libmcrypt rpm包,只能编译了.
                if CentOSVerCheck 7;then
                    other_option="--with-openssl  --with-zlib  --with-curl=shared  --with-gd=shared  --with-jpeg-dir  --with-png-dir  --with-freetype-dir  --with-mcrypt=shared,${depends_prefix}/${libmcrypt_filename}  --with-mhash=shared,${depends_prefix}/${mhash_filename}"
                else
                    other_option="--with-openssl  --with-zlib  --with-curl=shared  --with-gd=shared  --with-jpeg-dir  --with-png-dir  --with-freetype-dir  --with-mcrypt=shared  --with-mhash=shared "
                fi
                
            else
                other_option="--with-xml-config=${depends_prefix}/${libxml2_filename}/bin/xml2-config  --with-libxml-dir=${depends_prefix}/${libxml2_filename}  --with-openssl=${depends_prefix}/${openssl_filename}  --with-zlib=${depends_prefix}/${zlib_filename}  --with-zlib-dir=${depends_prefix}/${zlib_filename}  --with-curl=shared,${depends_prefix}/${libcurl_filename}  --with-pcre-dir=${depends_prefix}/${pcre_filename}  --with-openssl-dir=${depends_prefix}/${openssl_filename}  --with-gd=shared  --with-jpeg-dir=${depends_prefix}/${libjpeg_filename}   --with-png-dir=${depends_prefix}/${libpng_filename}  --with-freetype-dir=${depends_prefix}/${freetype_filename}  --with-mcrypt=shared,${depends_prefix}/${libmcrypt_filename}  --with-mhash=shared,${depends_prefix}/${mhash_filename}"
            fi

            php=${php5_2_filename}
            #php编译参数
            php_configure_args="--prefix=$php_location  --with-config-file-path=${php_location}/etc  ${php_run_php_mode}  --with-gettext=shared  --with-sqlite=shared  --with-pdo_sqlite=shared  --enable-bcmath=shared  --enable-ftp=shared  --enable-mbstring=shared  --with-iconv=shared  --enable-sockets=shared  --enable-zip  --enable-soap=shared  $other_option  ${with_mysql}  --without-pear  $lib64"

        else
            if if_in_array php5.3 "$package";then
                php=${php5_3_filename}
            elif if_in_array php5.4 "$package";then
                php=${php5_4_filename}
            elif if_in_array php5.5 "$package";then
                php=${php5_5_filename}
            elif if_in_array php5.6 "$package";then
                php=${php5_6_filename}
            elif if_in_array php7.0 "$package";then
                php=${php7_0_filename}
            fi        

            #判断php运行模式
            if [ "$php_mode" == "with_apache" ];then
                php_run_php_mode="--with-apxs2=${apache_location}/bin/apxs"
            elif [ "$php_mode" == "with_fastcgi" ];then
                php_run_php_mode="--enable-fpm"
            fi  

            if check_sys packageSupport;then
                #centos 7没有mhash和libmcrypt rpm包,只能编译了.
                if CentOSVerCheck 7;then
                    other_option="--with-openssl  --with-zlib  --with-curl=shared  --with-gd=shared  --with-jpeg-dir  --with-png-dir  --with-freetype-dir  --with-mcrypt=shared,${depends_prefix}/${libmcrypt_filename}  --with-mhash=shared,${depends_prefix}/${mhash_filename}"           
                else
                    other_option="--with-openssl  --with-zlib  --with-curl=shared  --with-gd=shared  --with-jpeg-dir  --with-png-dir  --with-freetype-dir  --with-mcrypt=shared  --with-mhash=shared"
                fi
                
            else
                other_option="--with-libxml-dir=${depends_prefix}/${libxml2_filename}  --with-openssl=${depends_prefix}/${openssl_filename}  --with-zlib=${depends_prefix}/${zlib_filename}  --with-zlib-dir=${depends_prefix}/${zlib_filename}  --with-curl=shared,${depends_prefix}/${libcurl_filename}  --with-pcre-dir=${depends_prefix}/${pcre_filename}  --with-openssl-dir=${depends_prefix}/${openssl_filename}  --with-gd=shared  --with-jpeg-dir=${depends_prefix}/${libjpeg_filename}   --with-png-dir=${depends_prefix}/${libpng_filename}  --with-freetype-dir=${depends_prefix}/${freetype_filename}  --with-mcrypt=shared,${depends_prefix}/${libmcrypt_filename}  --with-mhash=shared,${depends_prefix}/${mhash_filename}"
            fi

            # 5.5 5.6开启opcache
            if [[ "$php" == "${php5_5_filename}" || "$php" == "${php5_6_filename}" || "$php" == "${php7_0_filename}" ]]; then
                other_option="${other_option} --enable-opcache"
            fi
            php_configure_args="--prefix=$php_location  --with-config-file-path=${php_location}/etc  ${php_run_php_mode}  --enable-bcmath=shared  --with-pdo_sqlite=shared  --with-gettext=shared  --with-iconv=shared  --enable-ftp=shared  --with-sqlite=shared  --with-sqlite3=shared  --enable-mbstring=shared  --enable-sockets=shared  --enable-zip   --enable-soap=shared  $other_option   ${with_mysqlnd}  --without-pear  $lib64  --disable-fileinfo"
        fi        

        php_source_location=$cur_dir/soft/$php
        phpConfig=${php_location}/bin/php-config

        # 设置php模块
        php_modules_install=$( echo $php_modules_install | tr ',' ' ')
        if [[ "$php_modules_install" == "" ]]; then
            php_modules_install=do_not_install
        else
            php_version=$(echo $php | cut -c 5-7)
            php_module_support=$(list_php_modules $php_version)
            php_modules_valid=true
            for m in $php_modules_install;do
                if ! if_in_array "$m" "$php_module_support";then
                    php_modules_valid=false
                    echo "php module $m is not supported for $php"
                fi
            done
            $php_modules_valid || exit 1

            tmp=""
            if if_in_array ZendOptimizer "$php_modules_install";then
                tmp="$tmp ${ZendOptimizer_filename}"
            fi

            if if_in_array ZendGuardLoader "$php_modules_install";then
                tmp="$tmp ${ZendGuardLoader_filename}"
            fi    

            if if_in_array xcache "$php_modules_install";then
                tmp="$tmp ${xcache_filename}"
            fi 

            if if_in_array eaccelerator "$php_modules_install";then
                tmp="$tmp ${eaccelerator_filename}"
            fi 

            if if_in_array php_imagemagick "$php_modules_install";then
                tmp="$tmp ${php_imagemagick_filename}"
            fi 

            if if_in_array ionCube "$php_modules_install";then
                tmp="$tmp ${ionCube_filename}"
            fi 

            if if_in_array php_memcache "$php_modules_install";then
                tmp="$tmp ${php_memcache_filename}"
            fi 

            if if_in_array php_memcached "$php_modules_install";then
                tmp="$tmp ${php_memcached_filename}"
            fi 

            if if_in_array php_redis "$php_modules_install";then
                tmp="$tmp ${php_redis_filename}"
            fi 

            if if_in_array php_mongo "$php_modules_install";then
                tmp="$tmp ${php_mongo_filename}"
            fi 

            if if_in_array xdebug "$php_modules_install";then
                tmp="$tmp ${xdebug_filename}"
            fi 

            if if_in_array mssql "$php_modules_install";then
                tmp="$tmp mssql"
            fi 

            if if_in_array fileinfo "$php_modules_install";then
                tmp="$tmp fileinfo"
            fi 

            if if_in_array php-gmp "$php_modules_install";then
                tmp="$tmp php-gmp"
            fi 

            if if_in_array swoole "$php_modules_install";then
                tmp="$tmp swoole"
            fi                                                                                                 

            php_modules_install="$tmp"
        fi    

    else
        php=do_not_install
    fi

    # 设置其它软件
    other_soft_install=''
    if if_in_array tomcat7 "$package";then
        other_soft_install="$other_soft_install ${tomcat7_filename}"
        tomcat7_location=${tomcat_location:="/usr/local/tomcat7"}
        if path_valid "$tomcat7_location";then
            echo "--tomcat-prefix=$tomcat7_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$tomcat7_location" ]]; then
            echo "--tomcat-prefix=$tomcat7_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi

    if if_in_array tomcat8 "$package";then
        other_soft_install="$other_soft_install ${tomcat8_filename}"
        tomcat8_location=${tomcat_location:="/usr/local/tomcat8"}
        if path_valid "$tomcat8_location";then
            echo "--tomcat-prefix=$tomcat8_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$tomcat8_location" ]]; then
            echo "--tomcat-prefix=$tomcat8_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi         
    fi

    if if_in_array jdk7 "$package";then
        other_soft_install="$other_soft_install ${jdk7_filename}"
        jdk7_location=${jdk_location:="/usr/local/jdk7"}
        if path_valid "$jdk7_location";then
            echo "--jdk-prefix=$jdk7_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$jdk7_location" ]]; then
            echo "--jdk-prefix=$jdk7_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

        JAVA_HOME=$jdk7_location
    fi
    
    if if_in_array jdk8 "$package";then
        other_soft_install="$other_soft_install ${jdk8_filename}"
        jdk8_location=${jdk_location:="/usr/local/jdk8"}
        if path_valid "$jdk8_location";then
            echo "--jdk-prefix=$jdk8_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$jdk8_location" ]]; then
            echo "--jdk-prefix=$jdk8_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

        JAVA_HOME=$jdk8_location        
    fi

    if if_in_array memcached "$package";then
        other_soft_install="$other_soft_install ${memcached_filename}"
        memcached_location=${memcached_location:="/usr/local/memcached"}
        if path_valid "$memcached_location";then
            echo "--memcached-prefix=$memcached_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$memcached_location" ]]; then
            echo "--memcached-prefix=$memcached_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi

    if if_in_array mongodb "$package";then
        other_soft_install="$other_soft_install ${mongodb_filename}"

        # mongodb location
        mongodb_location=${mongodb_location:="/usr/local/mongodb"}
        if path_valid "$mongodb_location";then
            echo "--mongodb-prefix=$mongodb_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$mongodb_location" ]]; then
            echo "--mongodb-prefix=$mongodb_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

        # mongodb data location
        mongodb_data_location=${mongodb_data_location:="/usr/local/mongodb/data"}
        if path_valid "$mongodb_data_location";then
            echo "--mongodb-data=$mongodb_data_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$mongodb_data_location" ]]; then
            echo "--mongodb-data=$mongodb_data_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

    fi

    if if_in_array redis "$package";then
        other_soft_install="$other_soft_install ${redis_filename}"

        # redis location
        redis_location=${redis_location:="/usr/local/redis"}
        if path_valid "$redis_location";then
            echo "--redis-prefix=$redis_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$redis_location" ]]; then
            echo "--redis-prefix=$redis_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi

        # redis max memory
        if [[ "$redisMaxMemory" == "" ]]; then
            redisMaxMemory=$(awk -F':| +' '/MemTotal/{print $3*1024/2}' /proc/meminfo)
        else
            if ! echo "$redisMaxMemory" | grep -q -E "^[0-9]+[mMgG]$";then
                echo "--redis-maxmem $redisMaxMemory is invalid value, valid value ie.128M,512m,2G,4g"
                exit 1
            fi

            #转换成Byte
            if echo "$redisMaxMemory" | grep -q "[mM]$";then
                redisMaxMemory=`echo $redisMaxMemory | grep -o -E "[0-9]+"`
                ((redisMaxMemory=$redisMaxMemory*1024*1024))
            elif echo "$redisMaxMemory" | grep -q "[gG]$"; then
                redisMaxMemory=`echo $redisMaxMemory | grep -q -o -E "[0-9]+"`
                ((redisMaxMemory=$redisMaxMemory*1024*1024*1024))
            fi            
        fi    
    fi
    
    if if_in_array pureftpd "$package";then
        other_soft_install="$other_soft_install ${PureFTPd_filename}"

        pureftpd_location=${pureftpd_location:="/usr/local/pureftpd"}
        if path_valid "$pureftpd_location";then
            echo "--pureftpd-prefix=$pureftpd_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$pureftpd_location" ]]; then
            echo "--pureftpd-prefix=$pureftpd_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi

    if if_in_array phpmyadmin "$package";then
        other_soft_install="$other_soft_install ${phpMyAdmin_filename}"
        phpmyadmin_location=${phpmyadmin_location:="/home/wwwroot/phpmyadmin"}
        if path_valid "$phpmyadmin_location";then
            echo "--phpmyadmin-prefix=$phpmyadmin_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$phpmyadmin_location" ]]; then
            echo "--phpmyadmin-prefix=$phpmyadmin_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi

    if if_in_array phpredisadmin "$package";then
        other_soft_install="$other_soft_install ${phpRedisAdmin_filename}"
        phpredisadmin_location=${phpredisadmin_location:="/home/wwwroot/phpredisadmin"}
        if path_valid "$phpredisadmin_location";then
            echo "--phpredisadmin-prefix=$phpredisadmin_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$phpredisadmin_location" ]]; then
            echo "--phpredisadmin-prefix=$phpredisadmin_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi

    if if_in_array memadmin "$package";then
        other_soft_install="$other_soft_install ${memadmin_filename}"
        memadmin_location=${memadmin_location:="/home/wwwroot/memadmin"}
        if path_valid "$memadmin_location";then
            echo "--memadmin-prefix=$memadmin_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$memadmin_location" ]]; then
            echo "--memadmin-prefix=$memadmin_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi
    
    if if_in_array rockmongo "$package";then
        other_soft_install="$other_soft_install ${rockmongo_filename}"
        rockmongo_location=${rockmongo_location:="/home/wwwroot/rockmongo"}
        if path_valid "$rockmongo_location";then
            echo "--rockmongo-prefix=$rockmongo_location is invalid"
            exit 1
        fi
        
        if [[ $skip == false && -a "$rockmongo_location" ]]; then
            echo "--rockmongo-prefix=$rockmongo_location exists,please input other path or add --skip to disable path checking."
            exit 1
        fi        
    fi

    # 开始安装
    if [[ "$stack" == "lnmp" ]]; then
        install_lnmp
    elif [[ "$stack" == "lamp" ]]; then
        install_lamp
    elif [[ "$stack" == "lnamp" ]]; then
        install_lnamp
    fi
}


AVAILABLE_PACKAGES="nginx tengine openresty apache2.2 apache2.4 tomcat7 tomcat8 mysql5.1 
                    mysql5.5 mysql5.6 mysql5.7 php5.2 php5.3 php5.4 php5.5 php5.6 php7.0 
                    jdk7 jdk8 memcached mongodb redis pureftpd phpmyadmin phpredisadmin memadmin rockmongo"

AVAILABLE_NGINX_MODULES="lua-nginx-module nginx-http-concat nginx-upload-module ngx_http_substitutions_filter_module"

# 初始化
init

PARMS="$@"

# 解析命令行参数
TEMP=`getopt -o h --long help,skip,noscreen,stack:,package:,nginx-prefix:,nginx-module:,apache-prefix:,tomcat-prefix:,mysql-prefix:,mysql-data:,mysql-root-pwd:,mysql-port:,php-prefix:,php-module:,jdk-prefix:,memcached-prefix:,mongodb-prefix:,mongodb-data:,redis-prefix:,redis-maxmem:,pureftpd-prefix:,phpmyadmin-prefix:,phpredisadmin-prefix:,memadmin-prefix:,rockmongo-prefix:,list-php-modules: -- "$@"`
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"

skip=false
noscreen=false
while true ; do
    case "$1" in
        -h|--help) help ; exit 1 ;;
        --list-php-modules) list_php_modules $2 ; exit 1 ;;
        --skip) skip=true;shift 1 ;;
        --noscreen) noscreen=true;shift 1 ;;
        --stack) stack=$2 ; shift 2 ;;
        --package) package=$2 ; shift 2 ;;
        --nginx-prefix) nginx_location=$2 ; shift 2 ;;
        --nginx-module) nginx_modules_install=$2 ; shift 2 ;;
        --apache-prefix) apache_location=$2 ; shift 2 ;;
        --mysql-prefix) mysql_location=$2 ; shift 2 ;;
        --mysql-data) mysql_data_location=$2 ; shift 2 ;;
        --mysql-root-pwd) mysql_root_pass=$2 ; shift 2 ;;
        --mysql-port) mysql_port_number=$2 ; shift 2 ;;
        --php-prefix) php_location=$2 ; shift 2 ;;
        --php-module) php_modules_install=$2 ; shift 2 ;;
        --jdk-prefix) jdk_location=$2 ; shift 2 ;;
        --tomcat-prefix) tomcat_location=$2 ; shift 2 ;;
        --memcached-prefix) memadmin_location=$2 ; shift 2 ;;
        --mongodb-prefix) mongodb_location=$2 ; shift 2 ;;
        --mongodb-data) mongodb_data_location=$2 ; shift 2 ;;
        --redis-prefix) redis_location=$2 ; shift 2 ;;
        --redis-maxmem) redisMaxMemory=$2 ; shift 2 ;;
        --pureftpd-prefix) pureftpd_location=$2 ; shift 2 ;;
        --phpmyadmin-prefix) phpmyadmin_location=$2 ; shift 2 ;;
        --phpredisadmin-prefix) phpRedisAdmin_location=$2 ; shift 2 ;;
        --memadmin-prefix) memadmin_location=$2 ; shift 2 ;;
        --rockmongo-prefix) rockmongo_location=$2 ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# 尝试使用screen安装,避免与终端断开后停止安装
if ! $noscreen;then
    # 如果不在screen中
    if [[ "$TERM" != "screen" ]];then
        # 检测screen命令是否存在
        if command_is_exist screen;then
            screen -S ezhttp ./start.sh $PARMS
        else
            if check_sys packageManager apt;then
                apt-get update && apt-get -y install screen
            elif check_sys packageManager yum;then
                yum -y install screen
            else
                ./start.sh --noscreen $PARMS
            fi    

            if command_is_exist screen;then
                screen -S ezhttp ./start.sh $PARMS
            else
                echo "failed to install screen,starting without screen..."
                ./start.sh --noscreen $PARMS
            fi            
        fi
        exit   
    fi
fi

rm -f /root/ezhttp.log
if [[ "$stack" == "" ]]; then
    setup_by_menu
else
    setup_by_cmdline
fi

