Description
===========
ezhttp is a powerful bash script for the installation of web server(Apache,Nginx,PHP,MySQL and etc).You can install Apache Nginx PHP MySQL in an very easy way,Just need to input numbers to choose what you want to install before installation.And all things will be done in a few minutes.

Supported System
===============
* CentOS-5.x
* CentOS-6.x
* CentOS-7.x
* Ubuntu-12.04
* Ubuntu-14.04
* Ubuntu-16.04
* Debian-6
* Debian-7
* Debian-8
* Other Linux Distribution

Supported Software
==================
* Nginx OpenResty Tengine
* Nginx Module: lua_nginx_module nginx_concat_module nginx_upload_module ngx_substitutions_filter_module
* Apache-2.2 Apache-2.4
* MySQL-5.1 MySQL-5.5 MySQL-5.6 MySQL-5.7
* PHP-5.2 PHP-5.3 PHP-5.4 PHP-5.5 PHP-5.6 PHP-7.1
* PHP Module: ZendOptimizer ZendGuardLoader Xcache Eaccelerator Imagemagick IonCube Memcache Memcached Redis Mongo Xdebug Mssql
* Other Software: Memcached PureFtpd PhpMyAdmin Redis Mongodb PhpRedisAdmin MemAdmin RockMongo Jdk7 Jdk8 Tomcat7 Tomcat8

Useful Tools
============
* System_swap_settings - setup swap automatic
* Generate_mysql_my_cnf - generate mysql my.cnf configuration file according your server memory and other option you set.
* Create_rpm_package - package your software with rpm tool.
* Percona_xtrabackup_install - install xtrabackup.Helpful when need to backup the MySQL data.
* Change_sshd_port - change your sshd port automatic
* Iptables_settings - setup iptables in an easy way
* Enable_disable_php_extension - manage your PHP extensions
* Set_timezone_and_sync_time - setup system timezone and synchronize time with ntp
* Initialize_mysql_server - initialize mysql server data
* Add_chroot_shell_user - create a linux system user with a chroot home directory
* Network_analysis - this tool is definitely helpful when you need to know your network status.
* Backup_setup - powerful backup tool.

Installation
============
```bash
wget  https://github.com/centos-bz/ezhttp/archive/master.zip?time=$(date +%s) -O ezhttp.zip
unzip ezhttp.zip
cd ezhttp-master
chmod +x start.sh
```
Interactive installation
```bash
./start.sh
```

Non-interactive installation
```bash
./start.sh -h #  option h to print help info
```

Default Location
=============================
| Nginx Location             |                                  |
|----------------------------|----------------------------------|
| Install Prefix             | /usr/local/nginx                 |
| Main Configuration File    | /usr/local/nginx/conf/nginx.conf |
| Virtual Host Configuration | /usr/local/nginx/conf/vhost/     |

| Apache Location            |                                   |
|----------------------------|-----------------------------------|
| Install Prefix             | /usr/local/apache                 |
| Main Configuration File    | /usr/local/apache/conf/httpd.conf |
| Virtual Host Configuration | /usr/local/nginx/conf/vhost/      |

| PHP Location           |                               |
|------------------------|-------------------------------|
| Install Prefix         | /usr/local/php                |
| Ini Configuration File | /usr/local/php/etc/php.ini    |
| FPM Configuration File | /usr/local/apache/conf/vhost/ |

| MySQL Location            |                                       |
|---------------------------|---------------------------------------|
| Install Prefix            | /usr/local/mysql                      |
| Data Location             | /usr/local/mysql/data                 |
| my.cnf Configuration File | /usr/local/mysql/etc/my.cnf           |
| Error Log Location        | /usr/local/mysql/data/mysql-error.log |
| Slow Log Location         | /usr/local/mysql/data/mysql-slow.log  |

Process Management
==================
| Process | Command                                  |
|---------|------------------------------------------|
| nginx   | /etc/init.d/nginx (start\|stop\|restart)   |
| apache  | /etc/init.d/httpd (start\|stop\|restart)   |
| php-fpm | /etc/init.d/php-fpm (start\|stop\|restart) |
| mysql   | /etc/init.d/mysqld (start\|stop\|restart)  |

ez command description
=======================
| Command | Description                                  |
|---------|------------------------------------------|
| ez vhost add   | create virtual host   |
| ez vhost list  | list all virtual host   |
| ez vhost del | remove a virtual host |
| ez mysql reset  | reset mysql password  |
| ez mysql add  | create a mysql user   |
| ez mysql mod  | modify a mysql user   |
| ez mysql del  | delete a mysql user   |
| ez ftp add  | add a ftp user   |
| ez ftp list  | list ftp user   |
| ez ftp del  | delete a ftp user   |
| ez ftp mod  | modify a ftp user   |

Bugs & Issues
=============
Please feel free to report any bugs and issues to me, my email is: admin@centos.bz.  
中文支持:https://www.centos.bz/2017/02/ezhttp/
