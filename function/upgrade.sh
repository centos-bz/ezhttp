#更新软件菜单
upgrade_software(){
	clear
	display_menu upgrade
	if [ "$upgrade" == "Back_to_main_menu" ];then
		clear
		pre_setting
	else
		eval $upgrade
	fi
}

#升级nginx openresty tengine
Upgrade_nginx_tengine_openresty(){
	while true;do
		read -p "please input the nginx current location(default:/usr/local/nginx): " nginx_location
		nginx_location=${nginx_location:=/usr/local/nginx}
		nginx_location=`filter_location "$nginx_location"`
		if [[ -s ${nginx_location}/sbin/nginx ]];then
			break
		else
			echo "input error,${nginx_location}/sbin/nginx not found"
		fi
	done	
	#验证版本号
	version=$(${nginx_location}/sbin/nginx -v 2>&1)
	if ! echo $version | grep -q -E "^(Tengine|nginx)";then
		echo "$nginx_version nginx version is invalid version"
		exit 1
	fi	

	nginx_configure_args=$(${nginx_location}/sbin/nginx -V 2>&1 | sed -n -r 's/configure arguments:(.*)/\1/p')
	echo "your current version is ${version}"
	echo
	while true;do
		read -p "please input the new nginx version(ie.nginx-1.4.1 tengine-1.4.6 ngx_openresty-1.2.8.3): "  nginx_new_version
		#判断版本号是否有效
		if echo "$nginx_new_version" | grep -q -E '^nginx-[0-9]+\.[0-9]+\.[0-9]+$';then
			set_official_link_val $nginx_new_version "http://nginx.org/download/${nginx_new_version}.tar.gz"
			break
		elif echo "$nginx_new_version" | grep -q -E '^tengine-[0-9]+\.[0-9]+\.[0-9]+$';then
			official_link="http://tengine.taobao.org/download/${nginx_new_version}.tar.gz"
			break
		elif echo "$nginx_new_version" | grep -q -E '^ngx_openresty-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$';then
			set_official_link_val $nginx_new_version "http://openresty.org/download/${nginx_new_version}.tar.gz"
			nginx_location=$(echo $nginx_location | sed -r 's#nginx/?$##')
			nginx_configure_args="--prefix=${nginx_location} --with-luajit --with-http_ssl_module --with-openssl=$cur_dir/soft/${openssl_filename} --with-http_realip_module  --with-http_stub_status_module --with-pcre --with-pcre=$cur_dir/soft/${pcre_filename} --with-zlib=$cur_dir/soft/${zlib_filename} --with-http_secure_link_module --with-http_v2_module"
			break
		else
			echo "$nginx_new_version invalid,please reinput."
		fi
	done

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

	#升级nginx

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

	download_file  "${nginx_new_version}.tar.gz"
	cd $cur_dir/soft/
	tar xvzf ${nginx_new_version}.tar.gz
	cd ${nginx_new_version}
	make clean
	error_detect "./configure ${nginx_configure_args}"
	error_detect "make"
	error_detect "make install clean"

	old_pid=$(ps aux | grep "nginx: master process" | grep -v grep | awk '{print $2}')
	if echo $old_pid | grep -q -E "^[0-9]+$";then
		echo "current nginx master pid is $old_pid"
		echo "starting new nginx program now..."
		echo "we will still keep the old nginx process."
		kill -USR2 $old_pid
		sleep 3
		new_pid=$(ps aux | grep "nginx: master process" | grep -v grep | awk '{print $2}' | grep -v $old_pid)
		if echo $new_pid | grep -q -E "^[0-9]+$";then
			echo "start new nginx program successfully."
			echo "new nginx process pid is $new_pid"
			echo "start to kill the old nginx child process to let new nginx process serve request."
			kill -WINCH $old_pid
			sleep 3
			echo "kill old nginx child process done."
			echo "please check if the nginx service is normal."
			echo "input y will kill the old nginx master process,input n will start old nginx child process and kill new nginx process."
			yes_or_no "if your nginx service is ok,please input y,else input n.[Y/n]: " "echo 'start to replace old nginx process with new nginx process.';kill -QUIT ${old_pid}" "echo 'start rescore the old nginx process';kill -HUP ${old_pid};kill -QUIT ${new_pid};kill -TERM ${new_pid}"
			#等待旧nginx进程退出
			while true; do
				if [[ $(ps aux | grep "nginx: worker process is shutting down" | grep -v grep | wc -l) -eq 0 ]]; then
					break
				else
					echo "waiting the old nginx process quit..."
				fi
				sleep 2
			done

			if [[ $(ps aux | grep "nginx: master process" | grep -v grep | awk '{print $2}') == "${new_pid}" ]]; then
				echo "upgrade nginx successfully."
			else
				echo "upgrade nginx failed."
			fi	
		else
			echo "sorry,start new nginx program failed.please contact the author."
			echo "the old nginx process still serve the request."
			exit 1
		fi	

	else
		echo "can not get nginx master pid,may be nginx is not started,nginx is going to start..."
		/etc/init.d/nginx start
	fi

	exit
}	