#!/bin/bash
# Startup script for general process
# chkconfig: 345 85 15
# Description: Startup script for general process on Debian. Place in /etc/init.d and
# run 'update-rc.d -f httpd defaults', or use the appropriate command on your
# distro. For CentOS/Redhat run: 'chkconfig --add httpd'

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

check_process_running(){
	local process="$1"
	local result=`ps aux | grep "$process" | grep -v grep`
	if [[ "$result" == "" ]]; then
		return 1
	else
		return 0
	fi
}

start_process(){
	if check_process_running "$cmd";then
		echo "the $processName process is running,need not to start."
	else
		echo "starting $processName process..."
		$cmd
		echo "start done."
	fi
}


stop_process(){
	if check_process_running "$cmd";then
		echo "start to stop $processName process..."
		local pid=`ps aux | grep "$cmd" | grep -v grep | awk '{print $2}'`
		kill "$pid"
		echo "wait for 2 senconds..."
		sleep 2
		if check_process_running "$cmd";then
			echo "sorry,stop $processName process failed."
		else
			echo "stop $processName process successfully."
		fi	

	else
		echo "$processName process is not running,need not to stop."
	fi	
}

restart_process(){
	stop_process
	start_process
}

show_process_status(){
	if check_process_running "$cmd";then
		echo "$processName proccess is running."
	else
		echo "$processName proccess is not running."
	fi	
}


cmd=
processName=
action="$1"
case "$action" in
	start) start_process;;
	stop) stop_process;;
	restart) restart_process;;
	status) show_process_status;;
	*) echo "Usage: $0 {start|stop|restart}" 
	
esac
