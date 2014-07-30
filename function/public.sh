#随机生成密码
generate_password(){
	cat /dev/urandom | head -1 | md5sum | head -c 8
}

#杀掉进程
kill_pid(){
	local processType=$1
	local content=$2
	
	if [[ $processType == "port" ]]; then
		local port=$content
		if [[ `netstat -nlpt | awk '{print $4}' | grep ":${port}$"` != "" ]]; then
			processName=`netstat -nlp | grep -E ":${port} +" | awk '{print $7}' | awk -F'/' '{print $2}' | awk -F'.' 'NR==1{print $1}'`
			pid=`netstat -nlp | grep -E ":${port} +" | awk '{print $7}' | awk -F'/' 'NR==1{print $1}'`
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

	elif [[ $processType == "socket" ]]; then
		local socket=$content
		if [[ `netstat -nlp | awk '$1 ~/unix/{print $10}' | grep "^$socket$"` != "" ]]; then
			processName=`netstat -nlp | grep ${socket} | awk '{print $9}' | awk -F'/' '{print $2}'`
			pid=`netstat -nlp | grep $socket | awk '{print $9}' | awk -F'/' '{print $1}'`
			yes_or_no "We found socket $socket is occupied by process $processName.would you like to kill this proess [Y/n]: " "kill $pid" "echo 'will not kill this process.'"
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
local prompt="which ${soft} you'd select: "
eval local arr=(\${${soft}_arr[@]})
while true
do
	echo -e "#################### ${soft} setting ####################\n\n"
	for ((i=1;i<=${#arr[@]};i++ )); do echo -e "$i) ${arr[$i-1]}"; done
	echo
	read -p "${prompt}" $soft
	eval local select=\$$soft
	if [ "$select" == "" ] || [ "${arr[$soft-1]}" == ""  ];then
		prompt="input errors,please input a number: "
	else
		eval $soft=${arr[$soft-1]}
		eval echo "your selection: \$$soft"             
		break
	fi
done
}

#显示菜单(多选)
display_menu_multi(){
local soft=$1
local prompt="please input numbers(ie. 1 2 3): "
eval local arr=(\${${soft}_arr[@]})
local arr_len=${#arr[@]}

echo  "#################### $soft install ####################"
echo
for ((i=1;i<=$arr_len;i++ )); do echo -e "$i) ${arr[$i-1]}"; done
echo
while true
do
	read -p "${prompt}" select
	local select=($select)
	eval unset ${soft}_install
	unset wrong
	for j in ${select[@]}
	do
		if (! echo $j | grep -q -E "^[0-9]+$") || [[ $j -le 0 ]] || [[ $j -gt $arr_len ]];then
			prompt="input errors,please input numbers(ie. 1 2 3): ";
			wrong=1
			break
		elif [ "${arr[$j-1]}" == "do_not_install" ];then
			eval unset ${soft}_install
			eval ${soft}_install="do_not_install"
			break 2
		else
			eval ${soft}_install="\"\$${soft}_install ${arr[$j-1]}\""
			wrong=0
		fi
	done
	[ "$wrong" == 0 ] && break
done
eval echo -e "your selection \$${soft}_install"
}

#在/usr/lib创建库文件的链接
create_lib_link(){
        local lib=$1
        if [ ! -s "/usr/lib64/$lib" ] && [ ! -s "/usr/lib/$lib" ];then
                libdir=$(find /usr -name "$lib" | awk 'NR==1{print}')
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
local cur_soft=`pwd | awk -F'/' '{print $NF}'`
${command}
if [ $? != 0 ];then
	distro=`cat /etc/issue`
	version=`cat /proc/version`
	architecture=`uname -m`
	mem=`free -m`
	cat >>/root/ezhttp.log<<EOF
	ezhttp errors:
	distributions:$distro
	architecture:$architecture
	version:$version
	memery:
	${mem}
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

#判断路径输入是否合法
filter_location(){
local location=$1
if ! echo $location | grep -q "^/";then
	while true
	do
		read -p "input error,please input location again." location
		echo $location | grep -q "^/" && echo $location && break
	done
else
	echo $location
fi
}

#检查压缩包完善性
check_integrity(){
	local filename=$1
	if echo $filename | grep -q -E "(tar\.gz|tgz)$";then
		return `gzip -t ${cur_dir}/soft/$filename`
	elif echo $filename | grep -q -E "tar\.bz2$";then
		return `bzip2 -t ${cur_dir}/soft/$filename`
	fi
}

#下载软件
download_file(){
local url1=$1
local url2=$2
local filename=$3
if [ -s "${cur_dir}/soft/${filename}" ];then
	echo "${filename} is existed.check the file integrity."

	if check_integrity "${filename}";then
		echo "the file $filename is complete."
	else
		echo "the file $filename is incomplete.redownload now..."
		rm -f ${cur_dir}/soft/${filename}
		download_file "$url1" "$url2" "$filename"		
	fi

else
	[ ! -d "${cur_dir}/soft" ] && mkdir -p ${cur_dir}/soft
	cd ${cur_dir}/soft
	choose_url_download "$url1" "$url2" "$filename"
fi
}

#判断64位系统
is_64bit(){
	if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
		return 0
	else
		return 1
	fi		
}


#选择最优下载url
choose_url_download()
{
local url1=$1
local url2=$2
local filename=$3
#测试官方下载速度
echo "testing Official mirror download speed..."
speed2=`curl -m 5 -L -s -w '%{speed_download}' "$url2" -o /dev/null`
echo "Official mirror download speed is $speed2"

#测试第三方下载速度
echo "testing third party mirror download speed..."
speed1=`curl -m 5 -L -s -w '%{speed_download}' "$url1" -o /dev/null`
echo "third party mirror download speed is $speed1"
speed1=${speed1%%.*}
speed2=${speed2%%.*}
if [ $speed1 -ge $speed2 ];then
	url=$url1
	backup_url=$url2
else
	url=$url2
	backup_url=$url1
fi
echo "use the url $url to download $filename.."
sleep 1
#开始下载
wget_file "${url}" "${filename}" 

#测试下载文件完整性,不完整则使用第二个下载地址
if ! check_integrity ${filename};then
	wget_file "${backup_url}" "${filename}"
	#再次测试文件完整性
	if ! check_integrity ${filename};then
		echo "fail to download $filename with url $backup_url."
		echo "begin use backup url to download.."
		ez_url="https://www.lxconfig.com/files/ezhttp/$(echo $url1 | awk -F '/' '{print $NF}')"
		wget_file "${ez_url}" "${filename}"
		if ! check_integrity ${filename};then
			echo "fail to download $filename,exited."
			exit 1
		fi	
	fi
fi

}

#wget下载
wget_file(){
	local url=$1
	local filename=$2
	if ! wget --no-check-certificate --tries=3 ${url} -O $filename;then
		echo "fail to download $filename with url $url."
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


#判断命令是否存在
check_command_exist(){
local command=$1
if ! which $command > /dev/null;then
	echo "$command not found,please install it."
	exit 1
fi
}

#yes or no询问
yes_or_no(){
local prompt=$1
local yaction=$2
local naction=$3
while true; do
	read -p "${prompt}" yn
	yn=`upcase_to_lowcase $yn`
	case $yn in
		y ) eval "$yaction";break;;
		n ) eval "$naction";break;;
		* ) echo "input error,please only input y or n."
	esac
done
}

#安装编译工具
install_tool(){ 
	if check_sys packageManager apt;then
		apt-get -y update
		apt-get -y install gcc g++ make wget perl curl bzip2
	elif check_sys packageManager yum; then
		yum -y install gcc gcc-c++ make wget perl  curl bzip2 which
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
		release="unknow"
		systemPackage="unknow"
		packageSupport=false
	fi

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
local command=$1
local location=$2
if [ -d "$location" ];then
	echo "$location found,skip the installation."
	add_to_env "$location"
else
	${command}
fi
}

#检测是否安装,带确认对话
check_installed_ask(){
local command=$1
local location=$2
if [ -d "$location" ];then
	#发现路径存在，是否删除安装
	yes_or_no "directory $location found,may be the software had installed,remove it and reinstall it [N/y]: " "rm -rf $location && ${command}" "echo 'do not reinstall this software.' "
else
	${command}
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
	local code=$1
	local version="`VersionGet`"
	local main_ver=${version%%.*}
	if [ $main_ver == $code ];then
		return 0
	else
		return 1
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
	if $phpConfig --vernum | grep -q -E "^50[0-9]{3}$";then
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