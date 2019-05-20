#随机生成密码
generate_password(){
	cat /dev/urandom | head -1 | md5sum | head -c 8
}

# 转换为有效的变量名
get_valid_valname(){
	local val=$1
	local new_val=$(echo $val | sed 's/[-.]/_/g')
	echo $new_val
}

# 根据文件名设置md5变量,以便文件下载完成时能根据文件名取得md5值
set_md5(){
    local val=$1
    local md5=$2
    local new_val=$(get_valid_valname $val)
    eval md5_${new_val}="\$md5"
}

get_md5(){
	local val=$1
	local new_val=$(get_valid_valname $val)
	eval echo "\$md5_${new_val}"
}

get_md5_valname(){
	local val=$1
	local new_val=$(get_valid_valname $val)
	echo md5_$new_val
}

# 根据文件名设置dl变量
set_dl(){
    local val=$1
    local dl="$2"
    local new_val=$(get_valid_valname $val)
    # 下载链接防盗链
    current_time=$(date +%s)
    ((expire_time=$current_time + $allow_seconds))
    security_key=$(echo -n $safe_key$expire_time | md5sum | cut -d' ' -f 1)
    url_suffix="?ct_t=$expire_time\&ct_k=$security_key"
    dl_new=$(echo "$dl" | sed -r "s#(.)\$#\1$url_suffix#g")
    eval dl_${new_val}="\$dl_new"
}

get_dl(){
	local val=$1
	local new_val=$(get_valid_valname $val)
	eval echo "\$dl_${new_val}"
}

get_dl_valname(){
	local val=$1
	local new_val=$(get_valid_valname $val)
	echo dl_$new_val
}

# 根据文件名设置hint变量
set_hint(){
    local val=$1
    local hint="$2"
    local new_val=$(get_valid_valname $val)
    eval hint_${new_val}="\$hint"
}

get_hint(){
	local val=$1
	local new_val=$(get_valid_valname $val)
	eval echo "\$hint_${new_val}"
}

#杀掉进程
kill_pid(){
	local processType=$1
	local content=$2
	
	if [[ $processType == "port" ]]; then
		local port=$content
		if [[ `ss -nlpt | awk '{print $4}' | grep ":${port}$"` != "" ]]; then
			processName=`ss -nlp | grep -E ":${port} +" | awk '{sub("users:\(\(\"","",$7);sub("\".*","",$7);print $7}'`
			pid=`ss -nlp | grep -E ":${port} +"  | awk '{sub("[^,]+,","",$7);sub(",.*","",$7);print $7}'`
			yes_or_no "We found port $port is occupied by process $processName.would you like to kill this process [Y/n]: " "kill $pid" "echo 'will not kill this process.'"
			if [[ $yn == "y" ]];then
				echo "gonna be kill $processName process,please wait for 5 seconds..."
				sleep 5
				if [[ `ps aux | awk '{print $2}' | grep "^${pid}$"` == "" ]]; then
					echo "kill ${processName} successfully."
				else
					echo "kill ${processName} failed."
				fi
				sleep 2
			fi			
		fi
	else
		echo "unknow processType."
	fi

}

#显示菜单(单选)
display_menu(){
	local soft=$1
	local default=$2
	eval local arr=(\${${soft}_arr[@]})
	local default_prompt
	if [[ "$default" != "" ]]; then
		if [[ "$default" == "last" ]]; then
			default=${#arr[@]}
		fi
		default_prompt="(default ${arr[$default-1]})"
	fi
	local pick
	local hint
	local vname
	local prompt="which ${soft} you'd select${default_prompt}: "

	while true
	do
		echo -e "#################### ${soft} setting ####################\n\n"
		for ((i=1;i<=${#arr[@]};i++ )); do
			vname="$(get_valid_valname ${arr[$i-1]})"
			hint="$(get_hint $vname)"
			[[ "$hint" == "" ]] && hint="${arr[$i-1]}"
			echo -e "$i) $hint"
		done
		echo
		read -p "${prompt}" pick
		if [[ "$pick" == "" && "$default" != "" ]]; then
			pick=$default
			break
		fi

		if ! is_digit "$pick";then
			prompt="input errors,please input a number: "
			continue
		fi

		if [[ "$pick" -lt 1 || "$pick" -gt ${#arr[@]} ]]; then
			prompt="input errors,please input a number between 1 and ${#arr[@]}: "
			continue
		fi

		break
	done

	eval $soft=${arr[$pick-1]}
	vname="$(get_valid_valname ${arr[$pick-1]})"
	hint="$(get_hint $vname)"
	[[ "$hint" == "" ]] && hint="${arr[$pick-1]}"
	echo "your selection: $hint"
}

#显示菜单(多选)
display_menu_multi(){
	local soft=$1
	local default=$2
	eval local arr=(\${${soft}_arr[@]})
	local arr_len=${#arr[@]}
	local pick
	local correct=true
	local prompt
	local vname
	local hint
	local default_prompt
	if [[ "$default" != "" ]]; then
		if [[ "$default" == "last" ]];then
			default=$arr_len
		fi
		default_prompt="(default ${arr[$default-1]})"
		
	fi
	prompt="please input one or more number between 1 and ${arr_len}${default_prompt}(ie.1 2 3): "

	echo  "#################### $soft install ####################"
	echo
	for ((i=1;i<=$arr_len;i++ )); do
		vname="$(get_valid_valname ${arr[$i-1]})"
		hint="$(get_hint $vname)"
		[[ "$hint" == "" ]] && hint="${arr[$i-1]}"		
		echo -e "$i) $hint"
	done
	echo
	while true
	do
		read -p "${prompt}" pick
		pick=($pick)
		eval unset ${soft}_install
		if [[ "$pick" == "" ]]; then
			if [[ "$default" == "" ]]; then
				echo "input can not be empty,please reinput."
				continue
			else
				eval ${soft}_install="${arr[$default-1]}"
				break
			fi	
		fi

		for j in ${pick[@]}
		do
			if ! is_digit "$j";then
				echo "input error,please input a number"
				correct=false
				break 1
			fi	

			if [[ "$j" -lt 1 || "$j" -gt $arr_len ]]; then
				echo "input error,please input the number between 1 and ${arr_len}${default_prompt}."
				correct=false
				break 1
			fi

			if [ "${arr[$j-1]}" == "do_not_install" ];then
				eval ${soft}_install="do_not_install"
				break 2
			fi
				
			eval ${soft}_install="\"\$${soft}_install ${arr[$j-1]}\""
			correct=true

		done
		[[ "$correct" == true ]] && break

	done

	eval echo -e "your selection \$${soft}_install"
}

#在/usr/lib创建库文件的链接
create_lib_link(){
    local lib=$1
    if [ ! -s "/usr/lib64/$lib" ] && [ ! -s "/usr/lib/$lib" ];then
            libdir=$(find /usr/lib /usr/lib64 -name "$lib" | awk 'NR==1{print}')
            if [ "$libdir" != "" ];then
                    if is_64bit;then
			mkdir /usr/lib64
                            ln -s $libdir /usr/lib64/$lib
                            ln -s $libdir /usr/lib/$lib
                    else
                            ln -s $libdir /usr/lib/$lib
                    fi
            fi
    fi
    if is_64bit;then
	mkdir /usr/lib64
            [ ! -s "/usr/lib64/$lib" ] && [ -s "/usr/lib/$lib" ] && ln -s /usr/lib/${lib}  /usr/lib64/${lib}
            [ ! -s "/usr/lib/$lib" ] && [ -s "/usr/lib64/$lib" ] && ln -s /usr/lib64/${lib} /usr/lib/${lib}
    fi
}

#在64位时需要创建lib64目录
create_lib64_dir(){
	local dir=$1
	if is_64bit;then
		if [ -s "$dir/lib/" ] && [ ! -s  "$dir/lib64/" ];then
			cd $dir
			ln -s lib lib64
		fi		
	fi	
}

#监控编译安装中是否有错误，有错误就停止安装,并把错误写入到文件/root/ezhttp.log
error_detect(){
	local command=$1
	local work_dir=`pwd`
	local cur_soft=`echo ${work_dir#$cur_dir} | awk -F'/' '{print $3}'`
	${command}
	if [ $? != 0 ];then
		distro=`cat /etc/issue`
		version=`cat /proc/version`
		architecture=`uname -m`
		mem=`free -m`
		disk=`df -h`
		cat >>/root/ezhttp.log<<EOF
		ezhttp errors:
		distributions:$distro
		architecture:$architecture
		version:$version
		memery:
		${mem}
		disk:
		${disk}
		Nginx: ${nginx}
		Nginx compile parameter:${nginx_configure_args}
		Apache compile parameter:${apache_configure_args}
		MySQL Server: $mysql
		MySQL compile parameter: ${mysql_configure_args}
		PHP Version: $php
		php compile parameter: ${php_configure_args}
		Other Software: ${other_soft_install[@]}
		issue:failed to install $cur_soft
EOF
		echo "#########################################################"
		echo "failed to install $cur_soft."    
		echo "please visit website http://www.centos.bz/ezhttp/"
		echo "and submit /root/ezhttp.log ask for help."
		echo "#########################################################"
		exit 1
	fi
}

#保证是在根用户下运行
need_root_priv(){
	# Make sure only root can run our script
	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root" 1>&2
		exit 1
	fi
}

#禁止selinux，因为在selinux下会出现很多意想不到的问题
disable_selinux(){
	if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
		setenforce 0
	fi
}

#大写转换成小写
upcase_to_lowcase(){
	words=$1
	echo $words | tr '[A-Z]' '[a-z]'
}

#多核并行编译
parallel_make(){
	local para=$1
	cpunum=`cat /proc/cpuinfo |grep 'processor'|wc -l`

	#判断是否开启多核编译
	if [ $parallel_compile == 0 ];then
		cpunum=1
	fi

	if [ $cpunum == 1 ];then
		[ "$para" == "" ] && make || make "$para"
	else
		[ "$para" == "" ] && make -j$cpunum || 	make -j$cpunum "$para"
	fi	
}

#开机启动
boot_start(){
	if check_sys packageManager apt;then
		update-rc.d -f $1 defaults
	elif check_sys packageManager yum;then
		chkconfig --add $1
		chkconfig $1 on
	fi
}

#关闭开机启动
boot_stop(){
	if check_sys packageManager apt;then
		update-rc.d -f $1 remove
	elif check_sys packageManager yum;then
		chkconfig $1 off
	fi
}

#判断路径输入是否合法,不合法就要求重新输入
filter_location(){
	local location=$1
	if ! echo $location | grep -q "^/";then
		while true
		do
			read -p "input error,please input location again: " location
			echo $location | grep -q "^/" && echo $location && break
		done
	else
		echo $location
	fi
}

#判断路径是否合法,返回布尔
path_valid(){
	local location=$1
	if echo $location | grep -q "^/";then
		return 1
	fi

	return 0
}

#检查压缩包完善性
check_integrity(){
	local filename=$1
	if echo $filename | grep -q -E "(tar\.gz|tgz)$";then
		return `gzip -t ${cur_dir}/soft/$filename`
	elif echo $filename | grep -q -E "tar\.bz2$";then
		return `bzip2 -t ${cur_dir}/soft/$filename`
	elif echo $filename | grep -q -E "\.zip$"; then
		return `unzip -t -q ${cur_dir}/soft/$filename >/dev/null  2>&1`	
	elif echo $filename | grep -q -E "tar\.xz$"; then
		return `xz -t ${cur_dir}/soft/$filename >/dev/null  2>&1`		
	fi
}

# 检查文件完整性及md5
check_file_integrity_md5(){
	local filename=$1
	local filename_without_suffix=$(echo $filename | sed -r 's/\.(tar\.gz|tgz|tar\.bz2|zip)$//')
    local filename_val=$(get_valid_valname $filename_without_suffix)	
	local filepath=${cur_dir}/soft/${filename}

	if [[ -s "${filepath}" ]];then
		echo "check the file ${filepath} integrity."
		if check_integrity "${filename}";then
			echo "the file $filename is complete."
			echo "checking $filename md5..."

		    eval local md5_preset=$(get_md5 $filename_val)

			if ! which md5sum > /dev/null;then
				echo "Warning!md5sum command not found,ignore check file md5."
				return 0
			fi

		    if [[ "$md5_preset" == "" ]];then
		    	echo "Warning!$filename preset md5 not found,ignore checking md5."
		    	return 0
		    fi

		    local md5_cal=$(md5sum ${filepath}  | awk '{print $1}')
		    if [[ "$md5_preset" == "$md5_cal" ]];then
		    	echo "$filename is secure."
		    	return 0
		    else
		    	echo "Danger!The downloaded $filename md5 $md5_cal is not equal with the preset md5 $md5_preset."
		    	echo "It means the downloaded $filename had modified by someone or your network is insecure."
		    	echo "please report to the author admin@centos.bz."
		    	exit 1
		    fi

		else
			echo "the file $filename is incomplete.redownload now..."
			rm -f ${filepath}
			return 1
		fi
	else
		return 1
	fi		
}

# 下载文件
download_file(){
	local filename=$1
	local filename_without_suffix=$(echo $filename | sed -r 's/\.(tar\.gz|tgz|tar\.bz2|zip|tar\.xz)$//')
    local filename_val=$(get_valid_valname $filename_without_suffix)
    local dl_arr=($(get_dl $filename_val))
    local speed_tmp=/tmp/speed.txt
    local filepath=${cur_dir}/soft/${filename}
    local header

	if check_file_integrity_md5 $filename;then
		return
	fi
	    	    	
    local dl_num=${#dl_arr[@]}
    if [[ $dl_num -eq 0 ]];then
    	echo "there is no availabal download link for $filename."
    	exit 1
    fi

    if [[ $dl_num -ne 1 ]]; then	
	    rm -f $speed_tmp
	    # 分别获取各链接下载速度
	    for url in ${dl_arr[@]};do
	    	# oracle的下载链接需要带cookie
	    	header=""
	    	if [[ "$url" =~ oracle.com ]]; then
	    		header="Cookie: oraclelicense=accept-securebackup-cookie"
	    	fi
	    	echo "testing $url download speed..."
	        speed=`curl -m 5 -L -s -H "$header" -w '%{speed_download}' "$url" -o /dev/null`
	        speed=${speed%%.*}
	        echo "$speed $url" >> $speed_tmp
	        local bit
	        (( bit=$speed*8 ))
	        echo "$url download speed $(bit_to_human_readable $bit)"
	    done

	    # 按速度排序
	    dl_arr=($(sort -rn -k 1 $speed_tmp | awk '{print $2}'))

	fi

	[ ! -d "${cur_dir}/soft" ] && mkdir -p ${cur_dir}/soft
	cd ${cur_dir}/soft

    # 开始下载
    for url in ${dl_arr[@]};do
    	# oracle的下载链接需要带cookie
    	header=""
    	if [[ "$url" =~ oracle.com ]]; then
    		header="Cookie: oraclelicense=accept-securebackup-cookie"
    	fi
    	echo "start to download via $url..."
    	if ! wget --header="$header" --dns-timeout=5 --connect-timeout=10 --read-timeout=30 --no-check-certificate --tries=3 ${url} -O $filename;then
    		echo "download via $url failed,trying another mirror..."
    		continue
    	fi	

    	if check_file_integrity_md5 $filename;then
    		return
    	fi
    done

    echo "Oops!all mirror failed,please report to the author admin@centos.bz."
    exit 1
}

#判断64位系统
is_64bit(){
	if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
		return 0
	else
		return 1
	fi		
}

# 是否为数字
is_digit(){
	local input=$1
	if [[ "$input" =~ ^[0-9]+$ ]]; then
		return 0
	else
		return 1
	fi	
}

#验证ip合法性
verify_ip(){
	local ip=$1
	local i1=`echo $ip | awk -F'.' '{print $1}'`
	local i2=`echo $ip | awk -F'.' '{print $2}'`
	local i3=`echo $ip | awk -F'.' '{print $3}'`
	local i4=`echo $ip | awk -F'.' '{print $4}'`

	#检查第1位
	if ! echo $i1 | grep -E -q "^[0-9]+$" || [[ $i1 -eq 127 ]]  || [[ $i1 -le 0  ]] || [[ $i1 -ge 255 ]];then
		return 1
	fi
	
	#检查第2位
	if ! echo $i2 | grep -E -q "^[0-9]+$" || [[ $i2 -lt 0 ]] || [[ $i2 -gt 255 ]];then
		return 1
	fi

	#检查第3位
	if ! echo $i3 | grep -E -q "^[0-9]+$" || [[ $i3 -lt 0 ]] || [[ $i3 -gt 255 ]];then
		return 1
	fi

	#检查第4位
	if ! echo $i4 | grep -E -q "^[0-9]+$" || [[ $i4 -lt 0 ]] || [[ $i4 -gt 255 ]];then
		return 1
	fi		
	
	return 0
}

#验证端口合法性
verify_port(){
	local port=$1
	if echo $port | grep -q -E "^[0-9]+$";then
		if [[ "$port" -lt 0 ]] || [[ "$port" -gt 65535 ]];then
			return 1
		else
			return 0
		fi	
	else
		return 1
	fi		
}


#判断命令是否存在,不存在就退出
check_command_exist(){
    local command=$1
    IFS_SAVE="$IFS"
    IFS=":"
    local code
    for path in $PATH;do
        binPath="$path/$command"
        if [[ -f $binPath ]];then
    		IFS="$IFS_SAVE"
            return 0
        fi
    done
    IFS="$IFS_SAVE"
    echo "$command not found,please install it."
    exit 1

}

# 检测命令是否存在
command_is_exist(){
    local command=$1
    IFS_SAVE="$IFS"
    IFS=":"
    local code
    for path in $PATH;do
        binPath="$path/$command"
        if [[ -f $binPath ]];then
    		IFS="$IFS_SAVE"
            return 0
        fi
    done
    IFS="$IFS_SAVE"
    return 1	
}

#yes or no询问
yes_or_no(){
	local prompt=$1
	local yaction=$2
	local naction=$3
	local default=$4
	if [[ "$default" == "" ]]; then
		prompt="${prompt}: "
	else
		prompt="${prompt}(default $default): "
	fi	
	while true; do
		read -p "${prompt}" yn
		if [[ "$yn" == "" ]]; then
			yn="$default"
		fi		
		yn=`upcase_to_lowcase $yn`
		case $yn in
			y ) eval "$yaction";break;;
			n ) eval "$naction";break;;
			* ) echo "input error,please only input y or n."
		esac
	done
}

#非空值read
ask_not_null_var(){
	local prompt=$1
	local var=$2
	local default=$3
	local tmpVar=""
	while true; do
		read -p "$prompt" tmpVar
		[[ "$default" != "" ]] && tmpVar=${tmpVar:=$default}
		if [[ "$tmpVar" == "" ]]; then
			echo "the input can not be empty,please reinput."
		else
			eval $var="$tmpVar"
			break
		fi	
	done

}

#安装编译工具 （同时安装bzip2开发包，提供PHP开启bz2函数的依赖）
install_tool(){ 
	if check_sys packageManager apt;then
		apt-get -y update
		apt-get -y install gcc g++ make wget perl curl bzip2 libbz2-dev patch
	elif check_sys packageManager yum; then
		yum -y install gcc gcc-c++ make wget perl  curl bzip2 bzip2-devel which patch
	fi

	check_command_exist "gcc"
	check_command_exist "g++"
	check_command_exist "make"
	check_command_exist "wget"
	check_command_exist "perl"
}

#判断系统版本
check_sys(){
	local checkType=$1
	local value=$2

	local release=''
	local systemPackage=''
	local packageSupport=''

	. /tmp/ezhttp_sys_check_result > /dev/null 2>&1
	if [[ "$release" == "" ]] || [[ "$systemPackage" == "" ]] || [[ "$packageSupport" == "" ]];then

		if [[ -f /etc/redhat-release ]];then
			release="centos"
			systemPackage="yum"
			packageSupport=true

		elif cat /etc/issue | grep -q -E -i "debian";then
			release="debian"
			systemPackage="apt"
			packageSupport=true

		elif cat /etc/issue | grep -q -E -i "ubuntu";then
			release="ubuntu"
			systemPackage="apt"
			packageSupport=true

		elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
			release="centos"
			systemPackage="yum"
			packageSupport=true

		elif cat /proc/version | grep -q -E -i "debian";then
			release="debian"
			systemPackage="apt"
			packageSupport=true

		elif cat /proc/version | grep -q -E -i "ubuntu";then
			release="ubuntu"
			systemPackage="apt"
			packageSupport=true

		elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
			release="centos"
			systemPackage="yum"
			packageSupport=true

		else
			release="other"
			systemPackage="other"
			packageSupport=false
		fi

		# yes_or_no "ezhttp have detected your system as $release,is that correct?[Y/n]" "sys_correct=true;echo 'confirm correct.'" "sys_correct=false" y
		# if ! $sys_correct;then
		# 	while true;do
		# 		echo
		# 		echo -e "1) CentOS/Redhat\n2) Ubuntu\n3) Debian\n4) Others\n"
		# 		read -p "please choose the system release you'll install ezhttp.(input a number,ie. 1): " sys_release
		# 		if [[ "$sys_release" == "1" ]];then
		# 			release="centos"
		# 			systemPackage="yum"
		# 			packageSupport=true
		# 			break

		# 		elif [[ "$sys_release" == "2" ]]; then
		# 			release="ubuntu"
		# 			systemPackage="apt"
		# 			packageSupport=true
		# 			break

		# 		elif [[ "$sys_release" == "3" ]]; then
		# 			release="debian"
		# 			systemPackage="apt"
		# 			packageSupport=true
		# 			break

		# 		elif [[ "$sys_release" == "4" ]]; then
		# 			release="other"
		# 			systemPackage="other"
		# 			packageSupport=false
		# 			break

		# 		else
		# 			echo "your input is incorrect,please reinput a number."
		# 		fi	

		# 	done
		# fi
	fi

	echo -e "release=$release\nsystemPackage=$systemPackage\npackageSupport=$packageSupport\n" > /tmp/ezhttp_sys_check_result

	if [[ $checkType == "sysRelease" ]]; then
		if [ "$value" == "$release" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageManager" ]]; then
		if [ "$value" == "$systemPackage" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageSupport" ]]; then
		if $packageSupport;then
			return 0
		else
			return 1
		fi
	fi
}

#添加必要的环境变量
add_to_env(){
	local location=$1
	cd ${location} && [ ! -d lib ] && [ -d lib64 ] && ln -s lib64 lib
	[ -d "${location}/lib" ] && export LD_LIBRARY_PATH=${location}/lib:$LD_LIBRARY_PATH
	[ -d "${location}/bin" ] &&	export PATH=${location}/bin:$PATH
	[ -d "${location}/include" ] &&	export CPPFLAGS="-I${location}/include $CPPFLAGS"
}

#测试元素是否在数组里
if_in_array(){
	local element=$1
	local array=$2
	for i in $array
	do
		if [ "$i" == "$element" ];then
			return 0
		fi
	done
	return 1
}


#检测是否安装，存在就不安装了
check_installed(){
	local cmd=$1
	local location=$2
	if [ -d "$location" ];then
		echo "$location found,skip the installation."
		add_to_env "$location"
	else
		${cmd}
	fi
}

#获取版本号
VersionGet(){
	if [[ -s /etc/redhat-release ]];then
		grep -oE  "[0-9.]+" /etc/redhat-release
	else	
		grep -oE  "[0-9.]+" /etc/issue
	fi	
}

#判断centos版本
CentOSVerCheck(){
	if check_sys sysRelease centos;then
		local code=$1
		local version="`VersionGet`"
		local main_ver=${version%%.*}
		if [ $main_ver == $code ];then
			return 0
		else
			return 1
		fi
	else
		return 1
	fi
}

#判断 Ubuntu/Debian 版本 (请使用 codename)
OSVerCheck(){
	if check_sys sysRelease ubuntu || check_sys sysRelease debian;then
		local ver_code=$1
		local ver=`lsb_release -sc`
		if [ $ver == $ver_code ];then
			return 0
		else
			return 1
		fi
	fi
}

#重启php
restart_php(){
	eval `grep "stack=" /etc/ezhttp_info_do_not_del | tail -1`
	if [[ $stack == "lnamp" ]] || [[ $stack == "lamp" ]];then
		/etc/init.d/httpd restart
	elif [[ $stack == "lnmp" ]]; then
		service php-fpm restart
	else
		echo "can not restart php."
		exit 1
	fi	
}

#判断php-config是否正确
check_php_config(){
	local phpConfig=$1
	if $phpConfig --vernum | grep -q -E "^[5|7]0[0-9]{3}$";then
		return 0
	else
		return 1
	fi	
}

#获取php.ini路径
get_php_ini(){
	local phpConfig=$1
	check_php_config "$phpConfig" || ( echo "php config $phpConfig is invalid";exit 1) 
	$($phpConfig --php-binary) --ini | awk '/Loaded Configuration File/{print $4}'
}

#获取php二进制路径
get_php_bin(){
	local phpConfig=$1
	check_php_config "$phpConfig" || ( echo "php config $phpConfig is invalid";exit 1) 
	$phpConfig --php-binary
}

#获取php扩展目录
get_php_extension_dir(){
	local phpConfig=$1
	check_php_config "$phpConfig" || ( echo "php config $phpConfig is invalid";exit 1) 
	$phpConfig --extension-dir
}

#获取php版本
get_php_version(){
	local phpConfig=$1
	check_php_config "$phpConfig" || ( echo "php config $phpConfig is invalid";exit 1) 
	$phpConfig --version | cut -d'.' -f1-2	
}

#设置php参数
set_php_variable(){
	local key=$1
	local value=$2
	if grep -q -E "^$key\s*=" $php_location/etc/php.ini;then
		sed -i -r "s#^$key\s*=.*#$key=$value#" $php_location/etc/php.ini
	else
		sed -i -r "s#;\s*$key\s*=.*#$key=$value#" $php_location/etc/php.ini
	fi

	if ! grep -q -E "^$key\s*=" $php_location/etc/php.ini;then
		echo "$key=$value" >> $php_location/etc/php.ini
	fi
}

#获取ubuntu版本名称
get_ubuntu_version_name(){
	if [[ -s "/etc/lsb-release" ]];then
		version_name=`awk -F''= '/DISTRIB_CODENAME/{print $2}' /etc/lsb-release`
		if [[ $version_name == "" ]]; then
			echo "sorry,can not get ubuntu/debian version."
			exit 1
		else
			echo $version_name
		fi
	else
		echo "/etc/lsb-release not found,may be your system is not ubuntu/debian."
		exit 1
	fi	
}

#获取ubuntu版本号
get_ubuntu_version(){
	if [[ -s "/etc/lsb-release" ]];then
		version=`awk -F''= '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release`
		if [[ $version == "" ]];then
			echo "sorry,can not get ubuntu/debian version."
			exit 1
		else
			echo $version
		fi	
	else
		echo "/etc/lsb-release not found,may be your system is not ubuntu/debian."
		exit 1
	fi
}

#把带宽bit单位转换为人类可读单位
bit_to_human_readable(){
	#input bit value
	local trafficValue=$1

	if [[ ${trafficValue%.*} -gt 922 ]];then
		#conv to Kb
		trafficValue=`awk -v value=$trafficValue 'BEGIN{printf "%0.1f",value/1024}'`
		if [[ ${trafficValue%.*} -gt 922 ]];then
			#conv to Mb
			trafficValue=`awk -v value=$trafficValue 'BEGIN{printf "%0.1f",value/1024}'`
			echo "${trafficValue}Mb"
		else
			echo "${trafficValue}Kb"
		fi
	else
		echo "${trafficValue}b"
	fi
}

verify_cron_exp(){
	local exp1=`echo "$1" | awk '{print $1}'`
	local exp2=`echo "$1" | awk '{print $2}'` 
	local exp3=`echo "$1" | awk '{print $3}'` 
	local exp4=`echo "$1" | awk '{print $4}'` 
	local exp5=`echo "$1" | awk '{print $5}'`

	if [[ "$exp1" == "" || "$exp2" == "" || "$exp3" == "" || "$exp4" == "" || "$exp5" == "" ]]; then
		return 1
	fi

	exp1=`echo "$exp1" | grep -o -E "[^0].*$"`
	exp2=`echo "$exp2" | grep -o -E "[^0].*$"`
	exp3=`echo "$exp3" | grep -o -E "[^0].*$"`
	exp4=`echo "$exp4" | grep -o -E "[^0].*$"`
	exp5=`echo "$exp5" | grep -o -E "[^0].*$"`

	exp1="${exp1:=0}"
	exp2="${exp2:=0}"
	exp3="${exp3:=0}"
	exp4="${exp4:=0}"
	exp5="${exp5:=0}"

	if [[ "$exp1" != "*" && ( ! "$exp1" =~ ^[0-9]+$ || "$exp1" > 59 ) ]]; then
		return 1
	fi

	if [[ "$exp2" != "*" && ( ! "$exp2" =~ ^[0-9]+$ || "$exp2" > 23 ) ]]; then
		return 1
	fi

	if [[ "$exp3" != "*" && ( ! "$exp3" =~ ^[0-9]+$ || "$exp3" == "0" || "$exp3" > 31 ) ]]; then
		return 1
	fi

	if [[ "$exp4" != "*" && ( ! "$exp4" =~ ^[0-9]+$ || "$exp4" == "0" || "$exp4" > 12 ) ]]; then
		return 1
	fi

	if [[ "$exp5" != "*" && ( ! "$exp5" =~ ^[0-9]+$ || "$exp5" > 7 ) ]]; then
		return 1
	fi

	return 0

}
