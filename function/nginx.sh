#nginx安装前设置
nginx_preinstall_settings(){
	custom_info=""	
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
				nginx_other_link=""
				custom_info="$custom_info\nnginx_filename=$version\nnginx_official_link=$nginx_official_link\nnginx_other_link=''\n"
				break
			elif echo "$version" | grep -q -E '^tengine-[0-9]+\.[0-9]+\.[0-9]+$';then
				tengine_filename=$version
				nginx=$version
				tengine_official_link="http://tengine.taobao.org/download/${nginx}.tar.gz"
				tengine_other_link=""
				custom_info="$custom_info\ntengine_filename=$version\ntengine_official_link=$tengine_official_link\ntengine_other_link=''\n"
				break
			elif echo "$version" | grep -q -E '^ngx_openresty-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$';then
				openresty_filename=$version
				nginx=$version
				openresty_official_link="http://openresty.org/download/${nginx}.tar.gz"
				openresty_other_link=""
				custom_info="$custom_info\nopenresty_filename=$version\nopenresty_official_link=$openresty_official_link\nopenresty_other_link=''\n"
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

		#定义nginx编译参数
		if [ "$nginx" == "${nginx_filename}" ];then
			nginx_configure_args="--prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename}  --with-http_sub_module --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module"
		elif [ "$nginx" == "${tengine_filename}" ];then
			nginx_configure_args="--prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_concat_module --with-http_sysguard_module --with-http_upstream_check_module"
		elif [ "$nginx" == "${openresty_filename}" ];then
			nginx_configure_args="--prefix=${nginx_location} --with-luajit --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module"
		fi

		#提示是否更改编译参数
		echo -e "the $nginx configure parameter is:\n${nginx_configure_args}\n\n"
		yes_or_no "Would you like to change it [N/y]: " "read -p 'please input your new nginx configure parameter: ' nginx_configure_args" "echo 'you select no,configure parameter will not be changed.'"
		#检查编译参数是否为空
		while true; do
			if [ "$nginx_configure_args" == "" ];then
				echo "error.nginx configure parameter can not be empty,please reinput."
				read -p 'please input your new nginx configure parameter: ' nginx_configure_args
			else
				break
			fi	
		done
		[ "$yn" == "y" ] && echo -e "\nyour new nginx configure parameter is : ${nginx_configure_args}\n"		
	fi	
}


#安装nginx
install_nginx(){
#安装pcre
download_file "${pcre_other_link}" "${pcre_official_link}" "${pcre_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${pcre_filename}.tar.gz
#安装openssl
download_file "${openssl_other_link}" "${openssl_official_link}" "${openssl_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${openssl_filename}.tar.gz
#安装zlib
download_file "${zlib_other_link}" "${zlib_official_link}" "${zlib_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${zlib_filename}.tar.gz

if [ "$nginx" == "${nginx_filename}" ];then
	download_file "${nginx_other_link}" "${nginx_official_link}" "${nginx_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xvzf ${nginx_filename}.tar.gz
	cd ${nginx_filename}
	make clean
	error_detect "./configure ${nginx_configure_args}"
	error_detect "make"
	error_detect "make install"

elif [ "$nginx" == "${tengine_filename}" ];then
	download_file "${tengine_other_link}" "${tengine_official_link}" "${tengine_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${tengine_filename}.tar.gz
	cd ${tengine_filename}
	make clean
	error_detect "./configure ${nginx_configure_args}"
	error_detect "make"
	error_detect "make install"
	
elif [ "$nginx" == "${openresty_filename}" ];then
	download_file "${openresty_other_link}" "${openresty_official_link}" "${openresty_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${openresty_filename}.tar.gz
	cd ${openresty_filename}
	make clean	
	error_detect "./configure ${nginx_configure_args}"
	error_detect "make"
	error_detect "make install"
	#openresty的nginx路径会在下一级nginx目录
	nginx_location=${nginx_location}/nginx
fi

#配置nginx
config_nginx
#记录nginx安装位置
echo "nginx_location=$nginx_location" >> /etc/ezhttp_info_do_not_del
}

#配置nginx
config_nginx(){
groupadd www	
useradd -M -s /bin/false -g www www
mkdir -p ${nginx_location}/conf/vhost
mkdir -p /home/wwwroot/
\cp  -a $cur_dir/conf/rewrite ${nginx_location}/conf/
rm -f /etc/init.d/nginx
\cp  -f $cur_dir/conf/init.d.nginx /etc/init.d/nginx
sed -i "s#^nginx_location=.*#nginx_location=$nginx_location#" /etc/init.d/nginx
chmod +x /etc/init.d/nginx
\cp  $cur_dir/conf/index.html /home/wwwroot/
\cp  $cur_dir/conf/tz.php /home/wwwroot/
\cp  $cur_dir/conf/p.php /home/wwwroot/
boot_start nginx
mv ${nginx_location}/conf/nginx.conf ${nginx_location}/conf/nginx.conf_bak

if [ "$stack" == "lnamp" ];then
	\cp  -f $cur_dir/conf/nginx-lnamp.conf ${nginx_location}/conf/nginx.conf
	\cp -f $cur_dir/conf/proxy.conf ${nginx_location}/conf/
	#日志分割
	cat > /etc/logrotate.d/nginx <<EOF
	/home/wwwlog/*/access_nginx.log /home/wwwlog/*/error_nginx.log ${nginx_location}/logs/access.log ${nginx_location}/logs/error.log {
	    daily
	    rotate 14
	    missingok
	    notifempty
	    compress
	    sharedscripts
	    postrotate
	        [ ! -f ${nginx_location}/logs/nginx.pid ] || kill -USR1 \`cat ${nginx_location}/logs/nginx.pid\`
	    endscript
	}
EOF

else	
	\cp  -f $cur_dir/conf/nginx.conf ${nginx_location}/conf/

	#日志分割
	cat > /etc/logrotate.d/nginx <<EOF
	/home/wwwlog/*/access.log /home/wwwlog/*/error.log ${nginx_location}/logs/access.log ${nginx_location}/logs/error.log {
	    daily
	    rotate 14
	    missingok
	    notifempty
	    compress
	    sharedscripts
	    postrotate
	        [ ! -f ${nginx_location}/logs/nginx.pid ] || kill -USR1 \`cat ${nginx_location}/logs/nginx.pid\`
	    endscript
	}
EOF

fi

#开放80端口
iptables -I INPUT -p tcp --dport 80 -j ACCEPT

}