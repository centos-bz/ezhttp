#apache安装前设置
apache_preinstall_settings(){
display_menu apache last

#自定义版本支持
if [ "$apache" == "custom_version" ];then
	while true
	do
		read -p "input version.(ie.httpd-2.2.25 httpd-2.4.4): " version
		#判断版本号是否有效
		if echo "$version" | grep -q -E '^httpd-2\.2\.[0-9]+$';then
			apache2_2_filename=$version
			apache=$version
			read -p "please input $apache download url(must be tar.gz file format): "  link
			set_dl $version "$link"
			custom_info="$custom_info\napache2_2_filename=$version\n$(get_dl_valname $version)=$link\n"
			break
		elif echo "$version" | grep -q -E '^httpd-2\.4\.[0-9]+$';then
			apache2_4_filename=$version
			apache=$version
			read -p "please input $apache download url(must be tar.gz file format): " link
			set_dl $version "$link"
			custom_info="$custom_info\napache2_4_filename=$version\n$(get_dl_valname $version)=$link\n"
			break
		else
			echo "version invalid,please reinput."
		fi
	done	
fi	

if [ "$apache" != "do_not_install" ];then
	while true; do
		#apache安装路径
		read -p "$apache install location(default:/usr/local/apache,leave blank for default): " apache_location
		apache_location=${apache_location:="/usr/local/apache"}
		apache_location=`filter_location "$apache_location"`
		echo "$apache install location: $apache_location"
		if [[ -e $apache_location ]]; then
			yes_or_no "the location $apache_location found,maybe apache had been installed.skip apache installation?[Y/n]" "apache=do_not_install" "" y
			if [[ "$yn" == "n" ]]; then
				continue
			else
				break
			fi	
		else
			break
		fi	
	done

	if [[ "$apache" != "do_not_install" ]]; then
		#获取编译参数
		if [ "$apache" == "${apache2_2_filename}" ];then
			if check_sys packageSupport;then
				other_option=""
			else
				other_option="--with-z=${depends_prefix}/${zlib_filename} --with-ssl=${depends_prefix}/${openssl_filename}"
			fi	
			apache_configure_args="--prefix=${apache_location} --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared  --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support ${other_option}"
		elif [ "$apache" == "${apache2_4_filename}" ];then
			if check_sys packageSupport;then
				other_option=""
			else
				other_option="--with-z=${depends_prefix}/${zlib_filename} --with-ssl=${depends_prefix}/${openssl_filename} --with-pcre=${depends_prefix}/${pcre_filename}"
			fi	
			apache_configure_args="--prefix=${apache_location} --enable-so --enable-deflate=shared --enable-ssl=shared --enable-expires=shared  --enable-headers=shared --enable-rewrite=shared --enable-static-support  --with-included-apr $other_option"
		fi
		#提示是否更改编译参数
		echo -e "the $apache configure parameter is:\n${apache_configure_args}\n\n"
		yes_or_no "Would you like to change it?[N/y]" "read -p 'please input your new apache configure parameter: ' apache_configure_args" "echo 'you select no,configure parameter will not be changed.'" n
		if [[ "$yn" == "y" ]];then
			while true; do
				#检查编译参数是否为空
				if [ "$apache_configure_args" == "" ];then
					echo "input error.apache configure parameter can not be empty,please reinput."
					read -p 'please input your new apache configure parameter: ' apache_configure_args
					continue
				fi

				#检查是否设置prefix
				apache_location=$(echo "$apache_configure_args" | sed -r -n 's/.*--prefix=([^ ]*).*/\1/p')
				if [[ "$apache_location" == "" ]]; then
					echo "input error.apache configure parameter prefix can not be empty,please reinput."
					read -p 'please input your new apache configure parameter: ' apache_configure_args
					continue
				fi

				if [[ -e $apache_location ]]; then
					yes_or_no "the location $apache_location found,maybe apache had been installed.skip apache installation?[Y/n]" "apache=do_not_install" "" y
					if [[ "$yn" == "n" ]]; then
						read -p 'please input your new apache configure parameter: ' apache_configure_args
						continue
					else
						break
					fi
				fi
				break
			done
			[[ "$apache" != "do_not_install" ]] && echo -e "\nyour new apache configure parameter is : ${apache_configure_args}\n"
		fi
	fi
fi


}

#安装apache
install_apache(){
#安装依赖
if check_sys packageManager apt;then
	apt-get -y install libssl-dev
elif check_sys packageManager yum;then
	yum -y install zlib-devel openssl-devel
else
	check_installed "install_zlib " "${depends_prefix}/${zlib_filename}"
	check_installed "install_openssl" "${depends_prefix}/${openssl_filename}"
fi	


if [ "$apache" == "${apache2_2_filename}" ];then	
	download_file  "${apache2_2_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apache2_2_filename}.tar.gz
	cd ${apache2_2_filename}
	#解决SSL_PROTOCOL_SSLV2’ undeclared问题
	if grep -q -i "Ubuntu 12.04" /etc/issue;then
		sed -i '/SSL_PROTOCOL_SSLV2/d' $cur_dir/soft/${apache2_2_filename}/modules/ssl/ssl_engine_io.c
	fi 	
	make clean
	export LDFLAGS=-ldl
	error_detect "./configure $apache_configure_args"
	error_detect "parallel_make"
	error_detect "make install"
	unset LDFLAGS
	config_apache 2.2

elif [ "$apache" == "${apache2_4_filename}" ];then
	#安装依赖
	if check_sys packageManager apt;then
		apt-get -y install libpcre3-dev
	elif check_sys packageManager yum;then
		yum install -y pcre-devel
	else
		check_installed "install_pcre" "${depends_prefix}/${pcre_filename}"
	fi

	#安装apache 2.4时,pcre不能低于6.7
	if check_sys packageSupport;then
		pcreVersion=`pcre-config --version | tr -d '.'`
		if [[ $pcreVersion -lt 67 ]]; then
			apache_configure_args="$apache_configure_args --with-pcre=${depends_prefix}/${pcre_filename}"
			check_installed "install_pcre" "${depends_prefix}/${pcre_filename}"
		fi
	fi	

	#下载apr和apr-util
	download_file  "${apr_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apr_filename}.tar.gz
	download_file  "${apr_util_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apr_util_filename}.tar.gz

	download_file  "${apache2_4_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${apache2_4_filename}.tar.gz
	cd ${apache2_4_filename}
	\cp  -a ${cur_dir}/soft/${apr_filename} srclib/apr
	\cp  -a ${cur_dir}/soft/${apr_util_filename} srclib/apr-util
	make clean
	error_detect "./configure $apache_configure_args"
	error_detect "parallel_make"
	error_detect "make install"
	config_apache 2.4
fi
#记录apache安装位置
echo "apache_location=$apache_location" >> /etc/ezhttp_info_do_not_del
#清除openssl的LD_LIBRARY_PATH，以后出现no version information available
LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed "s#${depends_prefix}/${pcre_filename}:##")
export LD_LIBRARY_PATH
}

#配置apache
config_apache(){
groupadd www	
useradd  -M -s /bin/false -g www www
mkdir -p /home/wwwroot
local version=$1
\cp  -f ${apache_location}/conf/httpd.conf ${apache_location}/conf/httpd.conf_bak
grep -E -q "^\s*#\s*Include conf/extra/httpd-vhosts.conf" ${apache_location}/conf/httpd.conf  && sed -i 's#^\s*\#\s*Include conf/extra/httpd-vhosts.conf#Include conf/extra/httpd-vhosts.conf#' ${apache_location}/conf/httpd.conf || sed -i '$aInclude conf/extra/httpd-vhosts.conf' ${apache_location}/conf/httpd.conf
mv ${apache_location}/conf/extra/httpd-vhosts.conf ${apache_location}/conf/extra/httpd-vhosts.conf_bak
mkdir -p ${apache_location}/conf/vhost/

if [ "$stack" == "lnamp" ];then
	sed -i 's/Listen\s*80/Listen 127.0.0.1:88/' ${apache_location}/conf/httpd.conf
	listen="127.0.0.1:88"
	#日志分割
	cat > /etc/logrotate.d/httpd <<EOF
	/home/wwwlog/*/error_apache.log /home/wwwlog/*/access_apache.log ${apache_location}/logs/access_log ${apache_location}/logs/error_log {
	    daily
	    rotate 14
	    missingok
	    notifempty
	    compress
	    sharedscripts
	    postrotate
	        [ ! -f ${apache_location}/logs/httpd.pid ] || kill -USR1 \`cat ${apache_location}/logs/httpd.pid\`
	    endscript
	}
EOF

else
	listen="*:80"

	#日志分割
	cat > /etc/logrotate.d/httpd <<EOF
	/home/wwwlog/*/error.log /home/wwwlog/*/access.log ${apache_location}/logs/access_log ${apache_location}/logs/error_log {
	    daily
	    rotate 14
	    missingok
	    notifempty
	    compress
	    sharedscripts
	    postrotate
	        [ ! -f ${apache_location}/logs/httpd.pid ] || kill -USR1 \`cat ${apache_location}/logs/httpd.pid\`
	    endscript
	}
EOF

	#开放80端口
	iptables -I INPUT -p tcp --dport 80 -j ACCEPT
fi

#写入默认虚拟主机配置
cat > ${apache_location}/conf/extra/httpd-vhosts.conf <<EOF
NameVirtualHost ${listen}
<VirtualHost ${listen}>
ServerName localhost
ServerAlias localhost
DocumentRoot /home/wwwroot/
DirectoryIndex index.php index.html index.htm
<Directory /home/wwwroot/>
Options +Includes -Indexes
AllowOverride All
Order Deny,Allow
Allow from All
php_admin_value open_basedir /home/wwwroot/:/tmp:/proc
</Directory>
</VirtualHost>
Include ${apache_location}/conf/vhost/*.conf
EOF

#设置运行用户为www
sed -i 's/^User.*/User www/i' ${apache_location}/conf/httpd.conf
sed -i 's/^Group.*/Group www/i' ${apache_location}/conf/httpd.conf

#开启几个模块
sed -i -r 's/^#(.*mod_rewrite.so)/\1/' ${apache_location}/conf/httpd.conf
sed -i -r 's/^#(.*mod_deflate.so)/\1/' ${apache_location}/conf/httpd.conf
sed -i -r 's/^#(.*mod_expires.so)/\1/' ${apache_location}/conf/httpd.conf
sed -i -r 's/^#(.*mod_ssl.so)/\1/' ${apache_location}/conf/httpd.conf

#apache 2.4需要特别处理
if [ $version == "2.4" ];then
	sed -i '/NameVirtualHost/d' ${apache_location}/conf/extra/httpd-vhosts.conf
	sed -i 's/Allow from All/Require all granted/' ${apache_location}/conf/extra/httpd-vhosts.conf
	sed -i 's/^Include/IncludeOptional/' ${apache_location}/conf/extra/httpd-vhosts.conf
fi

rm -f /etc/init.d/httpd
\cp  -f $cur_dir/conf/init.d.httpd /etc/init.d/httpd
sed -i "s#^apache_location=.*#apache_location=$apache_location#" /etc/init.d/httpd
sed -i "s#^apache_location=.*#apache_location=$apache_location#" /etc/init.d/httpd
chmod +x /etc/init.d/httpd

\cp  $cur_dir/conf/index.html /home/wwwroot/
\cp  $cur_dir/conf/tz.php /home/wwwroot/
\cp  $cur_dir/conf/p.php /home/wwwroot/

boot_start httpd

}