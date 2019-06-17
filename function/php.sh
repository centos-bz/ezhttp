#php安装前设置
php_preinstall_settings(){
    display_menu php last
    #自定义版本支持
    if [ "$php" == "custom_version" ];then
        while true
        do
            read -p "input version.(ie.php-5.2.17 php-5.3.26 php-5.4.16 php-5.5.20): " version
            #判断版本号是否有效
            if echo "$version" | grep -q -E '^php-5\.2\.[0-9]+$';then
                php5_2_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): "  link
                set_dl $version "$link"
                custom_info="$custom_info\nphp5_2_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-5\.3\.[0-9]+$';then
                php5_3_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp5_3_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-5\.4\.[0-9]+$';then
                php5_4_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp5_4_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-5\.5\.[0-9]+$';then
                php5_5_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp5_5_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-5\.6\.[0-9]+$';then
                php5_6_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp5_6_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-7\.1\.[0-9]+$';then
                php7_1_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp7_1_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-7\.2\.[0-9]+$';then
                php7_2_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp7_2_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            elif echo "$version" | grep -q -E '^php-7\.3\.[0-9]+$';then
                php7_3_filename=$version
                php=$version
                read -p "please input $php download url(must be tar.gz file format): " link
                set_dl $version "$link"
                custom_info="$custom_info\nphp7_3_filename=$version\n$(get_dl_valname $version)=$link)\n"
                break
            else
                echo "version invalid,please reinput."
            fi
        done    
    fi  

    if [ "$php" != "do_not_install" ];then
        #判断当选择with_apache时，apache_location是否已经设置
        if [ "$apache_location" == "" ] && [ "$php_mode" == "with_apache" ];then
            read -p "apache location is not set,please input apache location: " apache_location
            apache_location=`filter_location "$apache_location"`
        fi

        #apache2.4与php5.2不兼容，需要判断一下
        if [ "$php_mode" == "with_apache" ] && [ "$apache" == "${apache2_4_filename}" ] && [ "$php" == "${php5_2_filename}" ];then
            echo "${apache2_4_filename} is not compatible with ${php5_2_filename},please reselect"
            php_preinstall_settings
        fi

        while true;do
            #php安装路径
            read -p "$php install location(default:/usr/local/php,leave blank for default): " php_location
            php_location=${php_location:=/usr/local/php}
            php_location=`filter_location "$php_location"`
            echo "$php install location: $php_location"
            if [[ -e $php_location ]]; then
                yes_or_no "the location $php_location found,maybe php had been installed.skip php installation?[Y/n]" "php=do_not_install" "" y
                if [[ "$yn" == "n" ]]; then
                    continue
                else
                    break
                fi  
            else
                break
            fi      
        done
        #当选择不安装mysql server且php为5.2版本时，询问是否让php支持mysql
        if [ "$mysql" == "do_not_install" ] && [ "$php" == "${php5_2_filename}" ];then
            yes_or_no "you do_not_install mysql server,but whether make php support mysql?[N/y]" "read -p 'set mysql server location: ' mysql_location" "unset mysql_location ; echo 'do not make php support mysql.'" n
        fi

        if [ "$php" != "do_not_install" ];then

            #获取编译参数

            #判断是否需要支持php mysql，否则取消php的--with-mysql编译参数
            [ "$mysql" == "do_not_install" ] && [ "$mysql_location" == "" ] && unset with_mysql || with_mysql="--with-mysql=$mysql_location --with-mysqli=$mysql_location/bin/mysql_config --with-pdo-mysql=$mysql_location/bin/mysql_config"

            #设置php5.3 php5.4 php5.5使用mysqlnd
            with_mysqlnd="--with-mysql=mysqlnd --with-mysqli=shared,mysqlnd --with-pdo-mysql=shared,mysqlnd"

            #判断是64系统就加上--with-libdir=lib64  
            is_64bit && lib64="--with-libdir=lib64" || lib64="" 

            if [ "$php" == "${php5_2_filename}" ];then

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

                #php编译参数
                php_configure_args="--prefix=$php_location  --with-config-file-path=${php_location}/etc  ${php_run_php_mode}  --with-gettext=shared  --with-sqlite  --with-pdo_sqlite  --enable-bcmath=shared  --enable-ftp=shared  --enable-mbstring=shared  --with-iconv  --enable-sockets=shared  --enable-zip  --enable-soap=shared  $other_option  ${with_mysql}  --without-pear  $lib64"

            elif [[ "$php" == "${php5_3_filename}" || "$php" == "${php5_4_filename}" || "$php" == "${php5_5_filename}" || "$php" == "${php5_6_filename}" || "$php" == "${php7_1_filename}" || "$php" == "${php7_2_filename}" || "$php" == "${php7_3_filename}" ]];then

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
                        other_option="--with-openssl  --with-zlib  --with-curl=shared  --with-gd=shared  --with-jpeg-dir  --with-png-dir  --with-mcrypt=shared  --with-mhash=shared"
                    fi
                    
                else
                    other_option="--with-libxml-dir=${depends_prefix}/${libxml2_filename}  --with-openssl=${depends_prefix}/${openssl_filename}  --with-zlib=${depends_prefix}/${zlib_filename}  --with-zlib-dir=${depends_prefix}/${zlib_filename}  --with-curl=shared,${depends_prefix}/${libcurl_filename}  --with-pcre-dir=${depends_prefix}/${pcre_filename}  --with-openssl-dir=${depends_prefix}/${openssl_filename}  --with-gd=shared  --with-jpeg-dir=${depends_prefix}/${libjpeg_filename}   --with-png-dir=${depends_prefix}/${libpng_filename}  --with-freetype-dir=${depends_prefix}/${freetype_filename}  --with-mcrypt=shared,${depends_prefix}/${libmcrypt_filename}  --with-mhash=shared,${depends_prefix}/${mhash_filename}"
                fi

                # 5.5 5.6开启opcache
                if [[ "$php" == "${php5_5_filename}" || "$php" == "${php5_6_filename}" || "$php" == "${php7_1_filename}" || "$php" == "${php7_2_filename}" || "$php" == "${php7_3_filename}" ]]; then
                    other_option="${other_option} --enable-opcache"
                fi

                #  >= PHP 5.6 在CentOS 6/7中重新编译libzip

                if [[ "$php" == "${php5_6_filename}" || "$php" == "${php7_1_filename}" || "$php" == "${php7_2_filename}" || "$php" == "${php7_3_filename}" ]]; then

                    if check_sys packageManager yum; then
                        yum remove libzip
                        other_option="${other_option} --with-libzip=${depends_prefix}/${libzip_filename}"
                    fi
                fi

                php_configure_args="--prefix=$php_location  --with-config-file-path=${php_location}/etc  ${php_run_php_mode}  --enable-bcmath=shared  --with-pdo_sqlite  --with-gettext=shared  --with-iconv --enable-ftp=shared  --with-sqlite  --with-sqlite3  --enable-mbstring=shared  --enable-sockets=shared  --enable-zip   --enable-soap=shared  $other_option   ${with_mysqlnd}  --without-pear  $lib64  --disable-fileinfo --enable-bcmath --enable-intl --with-bz2"
            fi  


            #提示是否更改编译参数
            php_configure_args=`echo $php_configure_args | sed -r 's/\s+/ /g'`
            echo -e "the $php configure parameter is:\n${php_configure_args}\n\n"
            yes_or_no "Would you like to change it?[N/y]" "read -p 'please input your new php configure parameter: ' php_configure_args" "echo 'you select no,configure parameter will not be changed.'" n
            if [[ "$yn" == "y" ]];then
                while true; do
                    #检查编译参数是否为空
                    if [ "$php_configure_args" == "" ];then
                        echo "input error.php configure parameter can not be empty,please reinput."
                        read -p 'please input your new php configure parameter: ' php_configure_args
                        continue
                    fi

                    #检查是否设置prefix
                    php_location=$(echo "$php_configure_args" | sed -r -n 's/.*--prefix=([^ ]*).*/\1/p')
                    if [[ "$php_location" == "" ]]; then
                        echo "input error.php configure parameter prefix can not be empty,please reinput."
                        read -p 'please input your new php configure parameter: ' php_configure_args
                        continue
                    fi
                    if [[ -e $php_location ]]; then
                        yes_or_no "the location $php_location found,maybe php had been installed.skip php installation?[Y/n]" "php=do_not_install" "" y
                        if [[ "$yn" == "n" ]]; then
                            read -p 'please input your new php configure parameter: ' php_configure_args
                            continue
                        else
                            break
                        fi
                    fi              
                    break
                done
                [[ "$php" != "do_not_install" ]] && echo -e "\nyour new php configure parameter is : ${php_configure_args}\n"
            fi
        fi
        
        # php源码位置
        php_source_location=$cur_dir/soft/$php
    fi
}

# 解决 freetype-config not found 的问题
fix_pkg_config() {
if check_sys packageManager apt; then
    local FreeTypeVer=`dpkg -s libfreetype6-dev | grep "Version:" `
    # local ICUVer=`dpkg -s libicu-dev | grep "Version:" `
    # if [[ "$FreeTypeVer" =~ "2.9.1-3" && "$ICUVer" =~ "63.1-6" ]];then
    if [[ "$FreeTypeVer" =~ "2.9.1-3" ]];then
        sed -i "s/freetype-config/pkg-config/g" ./configure
        sed -i "s/freetype-config/pkg-config/g" ./ext/gd/config.m4
        sed -i "s/FREETYPE2_CONFIG --cflags/FREETYPE2_CONFIG freetype2 --cflags/g" ./configure
        sed -i "s/FREETYPE2_CONFIG --libs/FREETYPE2_CONFIG freetype2 --cflags/g" ./configure
    fi
fi
}

#安装PHP
install_php(){
    #安装php依赖
    install_php_depends

    #解决freetype.h找不到的问题
    [ ! -f /usr/include/freetype2/freetype ] && [ ! -d /usr/include/freetype2/freetype ] &&  ln -sf /usr/include/freetype2 /usr/include/freetype2/freetype

    #开始安装php
    if [ "$php" == "${php5_2_filename}" ];then
        #安装依赖
        if check_sys packageManager apt;then
            apt-get -y install patch
        elif check_sys packageManager yum;then
            yum install -y patch
        else
            check_installed "install_patch" "${depends_prefix}/${patch_filename}"
        fi      

        download_file  "${php5_2_filename}.tar.gz"
        cd $cur_dir/soft/
        rm -rf ${php5_2_filename}
        tar xzvf ${php5_2_filename}.tar.gz
        #php-fpm补丁
        gzip -cd $cur_dir/conf/${php5_2_filename}-fpm-0.5.14.diff.gz | patch -d ${php5_2_filename} -p1
        cd ${php5_2_filename}
        fix_pkg_config
        #hash漏洞补丁
        \cp  $cur_dir/conf/${php5_2_filename}-max-input-vars.patch ./
        patch -p1 < ${php5_2_filename}-max-input-vars.patch

        # (PHP Multipart/form-data remote dos Vulnerability
        \cp $cur_dir/conf/php-5.2-multipart-form-data-remote-dos.patch ./
        patch -p1 < php-5.2-multipart-form-data-remote-dos.patch

        error_detect "./buildconf --force"
        error_detect "./configure ${php_configure_args}"
        if grep -q -i -E "ubuntu 12.04|ubuntu 14.04|debian.*7" /etc/issue;then
                #解决SSL_PROTOCOL_SSLV2’ undeclared问题
                cd ext/openssl/
                patch -p3 < $cur_dir/conf/debian_patches_disable_SSLv2_for_openssl_1_0_0.patch
                cd ../../
        fi

        if grep -q -i -E "ubuntu 14.04" /etc/issue;then
                # 解决ext/dom/node.c:1953:21: error: dereferencing pointer to incomplete type
                patch -p0 < $cur_dir/conf/php-5.2.17-dom-node.c.patch
        fi
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install"
        
        #配置php
        mkdir -p $php_location/etc/
        \cp  php.ini-recommended $php_location/etc/php.ini
        sed -i "s#extension_dir.*#extension_dir = \"${php_location}/lib/php/extensions/no-debug-non-zts-20060613\"#"  $php_location/etc/php.ini

    elif [ "$php" == "${php5_3_filename}" ];then
        download_file  "${php5_3_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php5_3_filename}.tar.gz
        cd ${php5_3_filename}
        fix_pkg_config
        # (PHP Multipart/form-data remote dos Vulnerability
        \cp $cur_dir/conf/php-5.3-multipart-form-data-remote-dos.patch ./
        patch -p1 < php-5.3-multipart-form-data-remote-dos.patch

        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf
        
    elif [ "$php" == "${php5_4_filename}" ];then
        download_file  "${php5_4_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php5_4_filename}.tar.gz
        cd ${php5_4_filename}
        fix_pkg_config
        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini   
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf

    elif [ "$php" == "${php5_5_filename}" ];then
        download_file  "${php5_5_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php5_5_filename}.tar.gz
        cd ${php5_5_filename}
        fix_pkg_config
        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini   
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf

    elif [ "$php" == "${php5_6_filename}" ];then
        download_file  "${php5_6_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php5_6_filename}.tar.gz
        cd ${php5_6_filename}
        fix_pkg_config
        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf 

    elif [ "$php" == "${php7_1_filename}" ];then
        download_file  "${php7_1_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php7_1_filename}.tar.gz
        cd ${php7_1_filename}
        fix_pkg_config
        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf 
    
    elif [ "$php" == "${php7_2_filename}" ];then
        download_file  "${php7_2_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php7_2_filename}.tar.gz
        cd ${php7_2_filename}
        fix_pkg_config
        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf
    
    elif [ "$php" == "${php7_3_filename}" ];then
        download_file  "${php7_3_filename}.tar.gz"
        cd $cur_dir/soft/
        tar xzvf ${php7_3_filename}.tar.gz
        cd ${php7_3_filename}
        fix_pkg_config
        make clean
        error_detect "./configure ${php_configure_args}"
        error_detect "parallel_make ZEND_EXTRA_LIBS='-liconv'"
        error_detect "make install" 
        
        #配置php
        mkdir -p ${php_location}/etc
        \cp  php.ini-production $php_location/etc/php.ini
        [ "$php_mode" == "with_fastcgi" ] && \cp  $php_location/etc/php-fpm.conf.default $php_location/etc/php-fpm.conf
    fi

    #记录php安装位置
    echo "php_location=$php_location" >> /etc/ezhttp_info_do_not_del

    #add php support for apache
    [ $php_mode == "with_apache" ] && ! grep -i "Addtype application/x-httpd-php .php" ${apache_location}/conf/httpd.conf && sed -i 's#AddType application/x-gzip .gz .tgz#AddType application/x-gzip .gz .tgz\nAddtype application/x-httpd-php .php#i' ${apache_location}/conf/httpd.conf

    #配置php
    config_php
}

#配置php
config_php(){
if [ "$php_mode" == "with_fastcgi" ];then   
    groupadd www    
    useradd  -M -s /bin/false -g www www
    rm -f /etc/init.d/php-fpm
    if [ "$php" == "${php5_2_filename}" ];then
        mkdir -p ${php_location}/logs/
        \cp -f $cur_dir/conf/init.d.php-fpm5.2 /etc/init.d/php-fpm
        sed -i "s#^php_location=.*#php_location=$php_location#" /etc/init.d/php-fpm
        chmod +x /etc/init.d/php-fpm
        sed -i  's#.*<value name="user">.*#<value name="user">www</value>#' ${php_location}/etc/php-fpm.conf

        set_php_variable safe_mode On
        set_php_variable disable_functions "dl,eval,assert,exec,popen,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open"
        set_php_variable expose_php Off
        set_php_variable error_log "${php_location}/logs/php-error.log"
        set_php_variable cgi.fix_pathinfo 0
        set_php_variable short_open_tag on
        set_php_variable date.timezone Asia/Chongqing

        #开启slow log
        sed -i 's#<value name="request_slowlog_timeout">0s</value>#<value name="request_slowlog_timeout">5s</value>#' $php_location/etc/php-fpm.conf

    elif [[ "$php" == "${php5_3_filename}" || "$php" == "${php5_4_filename}" || "$php" == "${php5_5_filename}" || "$php" == "${php5_6_filename}" ]]; then
        \cp $cur_dir/soft/${php}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
        chmod +x /etc/init.d/php-fpm
        sed -i 's/^user =.*/user = www/' ${php_location}/etc/php-fpm.conf
        sed -i 's/^group =.*/group = www/' ${php_location}/etc/php-fpm.conf

        set_php_variable disable_functions "dl,eval,assert,exec,popen,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open"
        set_php_variable expose_php Off
        set_php_variable error_log  ${php_location}/var/log/php_errors.log
        set_php_variable request_order  "CGP"
        set_php_variable cgi.fix_pathinfo 0
        set_php_variable short_open_tag on
        set_php_variable date.timezone Asia/Chongqing

        #开启slow log
        sed -i 's#;slowlog = log/$pool.log.slow#slowlog = var/log/$pool.log.slow#' ${php_location}/etc/php-fpm.conf
        sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5/' ${php_location}/etc/php-fpm.conf

    elif [[ "$php" == "${php7_1_filename}" ]]; then
        \cp $cur_dir/soft/${php}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
        chmod +x /etc/init.d/php-fpm
        \cp $php_location/etc/php-fpm.d/www.conf.default $php_location/etc/php-fpm.d/www.conf
        sed -i 's/^user =.*/user = www/' $php_location/etc/php-fpm.d/www.conf
        sed -i 's/^group =.*/group = www/' $php_location/etc/php-fpm.d/www.conf

        set_php_variable disable_functions "dl,eval,assert,exec,popen,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open"
        set_php_variable expose_php Off
        set_php_variable error_log  ${php_location}/var/log/php_errors.log
        set_php_variable request_order  "CGP"
        set_php_variable cgi.fix_pathinfo 0
        set_php_variable short_open_tag on
        set_php_variable date.timezone Asia/Shanghai

        #开启slow log
        sed -i 's#;slowlog = log/$pool.log.slow#slowlog = var/log/$pool.log.slow#' $php_location/etc/php-fpm.d/www.conf
        sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5/' $php_location/etc/php-fpm.d/www.conf       

    elif [[ "$php" == "${php7_2_filename}" ]]; then
        \cp $cur_dir/soft/${php}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
        chmod +x /etc/init.d/php-fpm
        \cp $php_location/etc/php-fpm.d/www.conf.default $php_location/etc/php-fpm.d/www.conf
        sed -i 's/^user =.*/user = www/' $php_location/etc/php-fpm.d/www.conf
        sed -i 's/^group =.*/group = www/' $php_location/etc/php-fpm.d/www.conf

        set_php_variable disable_functions "dl,eval,assert,exec,popen,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open"
        set_php_variable expose_php Off
        set_php_variable error_log  ${php_location}/var/log/php_errors.log
        set_php_variable request_order  "CGP"
        set_php_variable cgi.fix_pathinfo 0
        set_php_variable short_open_tag on
        set_php_variable date.timezone Asia/Shanghai

        #开启slow log
        sed -i 's#;slowlog = log/$pool.log.slow#slowlog = var/log/$pool.log.slow#' $php_location/etc/php-fpm.d/www.conf
        sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5/' $php_location/etc/php-fpm.d/www.conf       

    elif [[ "$php" == "${php7_3_filename}" ]]; then
        \cp $cur_dir/soft/${php}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
        chmod +x /etc/init.d/php-fpm
        \cp $php_location/etc/php-fpm.d/www.conf.default $php_location/etc/php-fpm.d/www.conf
        sed -i 's/^user =.*/user = www/' $php_location/etc/php-fpm.d/www.conf
        sed -i 's/^group =.*/group = www/' $php_location/etc/php-fpm.d/www.conf

        set_php_variable disable_functions "dl,eval,assert,exec,popen,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open"
        set_php_variable expose_php Off
        set_php_variable error_log  ${php_location}/var/log/php_errors.log
        set_php_variable request_order  "CGP"
        set_php_variable cgi.fix_pathinfo 0
        set_php_variable short_open_tag on
        set_php_variable date.timezone Asia/Shanghai

        #开启slow log
        sed -i 's#;slowlog = log/$pool.log.slow#slowlog = var/log/$pool.log.slow#' $php_location/etc/php-fpm.d/www.conf
        sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5/' $php_location/etc/php-fpm.d/www.conf       

    fi
    # 设置php_errors目录权限
    chown www ${php_location}/var/log/
    # 启用opcache
    if [[ "$php" == "${php5_5_filename}" || "$php" == "${php5_6_filename}" || "$php" == "${php7_1_filename}" || "$php" == "${php7_2_filename}" || "$php" == "${php7_3_filename}" ]];then
        cat >> $php_location/etc/php.ini <<EOF
[opcache]
zend_extension=opcache.so
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1 
EOF
    fi

    cp /etc/init.d/php-fpm /etc/init.d/php-fpm$(echo "$php" | grep -o -E '[0-9+]\.[0-9]+')
    boot_start php-fpm
fi

#设置php连接mysql mysql.sock的路径
[ -z ${mysql_data_location} ] && sock_location=/usr/local/mysql/data/mysql.sock || sock_location=${mysql_data_location}/mysql.sock
sed -i "s#mysql.default_socket.*#mysql.default_socket = ${sock_location}#" $php_location/etc/php.ini
sed -i "s#mysqli.default_socket.*#mysqli.default_socket = ${sock_location}#" $php_location/etc/php.ini
sed -i "s#pdo_mysql.default_socket.*#pdo_mysql.default_socket = ${sock_location}#" $php_location/etc/php.ini

#默认开启一些扩展
echo "extension=curl.so" >> ${php_location}/etc/php.ini
echo "extension=gd.so" >> ${php_location}/etc/php.ini
echo "extension=mbstring.so" >> ${php_location}/etc/php.ini
echo "extension=pdo_mysql.so" >> ${php_location}/etc/php.ini
echo "extension=mysqli.so" >> ${php_location}/etc/php.ini

}
