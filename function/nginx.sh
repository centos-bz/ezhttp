#nginx安装前设置
nginx_preinstall_settings(){
	custom_info=""	
	display_menu nginx last
	#自定义版本支持
	if [ "$nginx" == "custom_version" ];then
		while true
		do
			read -p "input version.(ie.nginx-1.4.1 tengine-1.4.6 ngx_openresty-1.2.8.3): " version
			#判断版本号是否有效
			if echo "$version" | grep -q -E '^nginx-[0-9]+\.[0-9]+\.[0-9]+$';then
				nginx_filename=$version
				nginx=$version
				set_dl $version "http://nginx.org/download/${nginx}.tar.gz"
				custom_info="$custom_info\nnginx_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
				break
			elif echo "$version" | grep -q -E '^tengine-[0-9]+\.[0-9]+\.[0-9]+$';then
				tengine_filename=$version
				nginx=$version
				set_dl $version "http://tengine.taobao.org/download/${nginx}.tar.gz"
				custom_info="$custom_info\ntengine_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
				break
			elif echo "$version" | grep -q -E '^ngx_openresty-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$';then
				openresty_filename=$version
				nginx=$version
				set_dl $version "http://openresty.org/download/${nginx}.tar.gz"
				custom_info="$custom_info\nopenresty_filename=$version\n$(get_dl_valname $version)=$(get_dl $version)\n"
				break
			else
				echo "version invalid,please reinput."
			fi
		done
	fi	

	if [ "$nginx" != "do_not_install" ];then
		while true;do
			#设置默认路径
			[ "$nginx" == "${openresty_filename}" ] && nginx_default=/usr/local/openresty || nginx_default=/usr/local/nginx
			#nginx安装路径
			read -p "$nginx install location(default:$nginx_default,leave blank for default): " nginx_location
			#设置默认openresty的prefix为/usr/local,则nginx将安装在/usr/local/nginx
			nginx_location=${nginx_location:=$nginx_default}
			nginx_location=`filter_location "$nginx_location"`
			#nginx安装目录会在openresty的下级nginx目录
			[ "$nginx" == "${openresty_filename}" ] && echo "openresty location $nginx_location,nginx location ${nginx_location}/nginx" || echo "$nginx install location: $nginx_location"

			if [[ -e $nginx_location ]]; then
				yes_or_no "the location $nginx_location found,maybe nginx had been installed.skip nginx installation?[Y/n]" "nginx=do_not_install" "" y
				if [[ "$yn" == "n" ]]; then
					continue
				else
					break
				fi	
			else
				break
			fi
		done	

		if [ "$nginx" != "do_not_install" ];then
			#定义nginx编译参数
			if [ "$nginx" == "${nginx_filename}" ];then
				nginx_configure_args="--prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename}  --with-http_sub_module --with-http_stub_status_module --with-pcre-jit --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_v2_module"
			elif [ "$nginx" == "${tengine_filename}" ];then
				nginx_configure_args="--prefix=${nginx_location} --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre-jit --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_concat_module --with-http_sysguard_module --with-http_upstream_check_module --with-http_v2_module"
			elif [ "$nginx" == "${openresty_filename}" ];then
				nginx_configure_args="--prefix=${nginx_location} --with-luajit --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre-jit --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_v2_module"
			fi

			#提示是否更改编译参数
			echo -e "the $nginx configure parameter is:\n${nginx_configure_args}\n\n"
			yes_or_no "Would you like to change it?[N/y]" "read -p 'please input your new nginx configure parameter: ' nginx_configure_args" "echo 'you select no,configure parameter will not be changed.'" n
		
			if [[ "$yn" == "y" ]];then
				while true; do
					#检查编译参数是否为空
					if [ "$nginx_configure_args" == "" ];then
						echo "input error.nginx configure parameter can not be empty,please reinput."
						read -p 'please input your new nginx configure parameter: ' nginx_configure_args
						continue
					fi

					#检查是否设置prefix
					nginx_location=$(echo "$nginx_configure_args" | sed -r -n 's/.*--prefix=([^ ]*).*/\1/p')
					if [[ "$nginx_location" == "" ]]; then
						echo "input error.nginx configure parameter prefix can not be empty,please reinput."
						read -p 'please input your new nginx configure parameter: ' nginx_configure_args
						continue
					fi
					if [[ -e $nginx_location ]]; then
						yes_or_no "the location $nginx_location found,maybe nginx had been installed.skip nginx installation?[Y/n]" "nginx=do_not_install" "" y
						if [[ "$yn" == "n" ]]; then
							read -p 'please input your new nginx configure parameter: ' nginx_configure_args
							continue
						else
							break
						fi
					fi					
					break
				done
				[[ "$nginx" != "do_not_install" ]] && echo -e "\nyour new nginx configure parameter is : ${nginx_configure_args}\n"
			fi
		fi
	fi

	# nginx模块设置
	if [[ "$nginx" != "do_not_install" ]];then
		echo
		yes_or_no "Do you need to install nginx module?[N/y]" "" "" n
		if [[ "$yn" == "y" ]]; then
			if [[ "$nginx" == "${openresty_filename}" ]]; then
				# openresty已经自带lua,从菜单删除
				nginx_modules_arr=(${nginx_modules_arr[@]#${lua_nginx_module_filename}})
			fi

			if [[ "$nginx" == "${tengine_filename}" ]]; then
				# tengine已经自带concat,从菜单删除
				nginx_modules_arr=(${nginx_modules_arr[@]#${nginx_concat_module_filename}})
			fi
			display_menu_multi nginx_modules last

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

			if if_in_array "ngx_stream_core_module" "$nginx_modules_install";then
				nginx_configure_args="${nginx_configure_args} --with-stream"
			fi

			if if_in_array "${nginx_upstream_check_module_filename}" "$nginx_modules_install";then
				nginx_configure_args="${nginx_configure_args} --add-module=$cur_dir/soft/${nginx_upstream_check_module_filename}"
			fi
		
			if if_in_array "${nginx_stream_upsync_module_filename}" "$nginx_modules_install";then
				if if_in_array "ngx_stream_core_module" "$nginx_modules_install";then
					nginx_configure_args="${nginx_configure_args} --add-module=$cur_dir/soft/${nginx_stream_upsync_module_filename}"
				else				
					nginx_configure_args="${nginx_configure_args}  --with-stream --add-module=$cur_dir/soft/${nginx_stream_upsync_module_filename}"
				fi	
			fi			

		fi
	fi

}

# 安装luajit
install_luajit(){
	download_file "${luajit_filename}.tar.gz"
	cd $cur_dir/soft/
	rm -rf ${luajit_filename}
	tar xzvf ${luajit_filename}.tar.gz
	cd ${luajit_filename}
	error_detect "parallel_make PREFIX=${depends_prefix}/${luajit_filename}"
	error_detect "make install PREFIX=${depends_prefix}/${luajit_filename}"
	add_to_env "${depends_prefix}/${luajit_filename}"
	echo "${depends_prefix}/${luajit_filename}/lib/" > /etc/ld.so.conf.d/luajit.conf
	ldconfig
}

# 安装模块
install_module(){
	if if_in_array "${lua_nginx_module_filename}" "$nginx_modules_install";then
		check_installed install_luajit ${depends_prefix}/${luajit_filename}
		export LUAJIT_LIB=${depends_prefix}/${luajit_filename}/lib
		export LUAJIT_INC=${depends_prefix}/${luajit_filename}/include/luajit-2.0

		download_file "${ngx_devel_kit_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${ngx_devel_kit_filename}.tar.gz

		download_file "${lua_nginx_module_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${lua_nginx_module_filename}.tar.gz

	fi

	if if_in_array "${nginx_concat_module_filename}" "$nginx_modules_install";then
		download_file "${nginx_concat_module_filename}.tar.gz"
		cd $cur_dir/soft/
		rm -rf ${nginx_concat_module_filename}
		tar xzvf ${nginx_concat_module_filename}.tar.gz
	fi

	if if_in_array "${nginx_upload_module_filename}" "$nginx_modules_install";then
		download_file "${nginx_upload_module_filename}.zip"
		cd $cur_dir/soft/
		rm -rf ${nginx_upload_module_filename}
		unzip ${nginx_upload_module_filename}.zip
	fi

	if if_in_array "${ngx_substitutions_filter_module_filename}" "$nginx_modules_install";then
		download_file "${ngx_substitutions_filter_module_filename}.tar.gz"
		cd $cur_dir/soft/
		rm -rf ${ngx_substitutions_filter_module_filename}
		tar xzvf ${ngx_substitutions_filter_module_filename}.tar.gz
	fi

	if if_in_array "${nginx_upstream_check_module_filename}" "$nginx_modules_install";then
		download_file "${nginx_upstream_check_module_filename}.zip"
		cd $cur_dir/soft/
		rm -rf ${nginx_upstream_check_module_filename}
		unzip ${nginx_upstream_check_module_filename}.zip
	fi	

	if if_in_array "${nginx_stream_upsync_module_filename}" "$nginx_modules_install";then
		download_file "${nginx_stream_upsync_module_filename}.zip"
		cd $cur_dir/soft/
		rm -rf ${nginx_stream_upsync_module_filename}
		unzip ${nginx_stream_upsync_module_filename}.zip
	fi

}

#安装nginx
install_nginx(){
	# 安装模块
	install_module
	#安装pcre
	download_file  "${pcre_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${pcre_filename}.tar.gz
	#安装openssl
	download_file  "${openssl_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${openssl_filename}.tar.gz
	#安装zlib
	download_file  "${zlib_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${zlib_filename}.tar.gz

	if [ "$nginx" == "${nginx_filename}" ];then
		download_file  "${nginx_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xvzf ${nginx_filename}.tar.gz
		cd ${nginx_filename}
		make clean

		if if_in_array "${nginx_upstream_check_module_filename}" "$nginx_modules_install";then
			patch -p0 < $cur_dir/soft/${nginx_upstream_check_module_filename}/check_1.9.2+.patch
		fi
		
		error_detect "./configure ${nginx_configure_args}"
		error_detect "make"
		error_detect "make install"

	elif [ "$nginx" == "${tengine_filename}" ];then
		download_file  "${tengine_filename}.tar.gz"
		cd $cur_dir/soft/
		tar xzvf ${tengine_filename}.tar.gz
		cd ${tengine_filename}
		make clean
		error_detect "./configure ${nginx_configure_args}"
		error_detect "make"
		error_detect "make install"
		
	elif [ "$nginx" == "${openresty_filename}" ];then
		download_file  "${openresty_filename}.tar.gz"
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
	load_iptables_onboot
	save_iptables

}