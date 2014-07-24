#安装php依赖
install_php_depends(){
	#安装libiconv
	if [ ! -f "/usr/lib/libiconv.so" ] && [ ! -f "/usr/lib64/libiconv.so" ];then
		install_libiconv
	fi
	
	#安装依赖
	if check_sys packageManager apt;then
		local packages=(m4 autoconf libcurl4-gnutls-dev  autoconf2.13 libxml2-dev openssl zlib1g-dev libpcre3-dev libtool libjpeg-dev libpng12-dev libfreetype6-dev libmhash-dev libmcrypt-dev libssl-dev)
		for p in ${packages[@]}
		do
			apt-get -y install $p
		done
		create_lib_link "libjpeg.so"
		create_lib_link "libpng.so"
		create_lib_link "libltdl.so"
		create_lib_link "libmcrypt.so"
		create_lib_link "libiconv.so"
		create_lib_link "libiconv.so.2"
	elif check_sys packageManager yum;then
		yum -y install m4 autoconf libxml2-devel openssl openssl-devel  zlib-devel curl-devel pcre-devel libtool-libs libtool-ltdl-devel libjpeg-devel libpng-devel freetype-devel mhash-devel libmcrypt-devel
		create_lib_link "libjpeg.so"
		create_lib_link "libpng.so"
		create_lib_link "libltdl.so"
		create_lib_link "libmcrypt.so"
		create_lib_link "libiconv.so"
		create_lib_link "libiconv.so.2"
		#解决centos 6 libmcrypt和libmhash不在在的问题
		if CentOSVerCheck 6;then
			if is_64bit; then
				rpm -i $cur_dir/conf/libmcrypt-2.5.7-1.2.el6.rf.x86_64.rpm
				rpm -i $cur_dir/conf/libmcrypt-devel-2.5.7-1.2.el6.rf.x86_64.rpm
				rpm -i $cur_dir/conf/mhash-0.9.9.9-3.el6.x86_64.rpm
				rpm -i $cur_dir/conf/mhash-devel-0.9.9.9-3.el6.x86_64.rpm
			else
				rpm -i $cur_dir/conf/libmcrypt-2.5.7-1.2.el6.rf.i686.rpm
				rpm -i $cur_dir/conf/libmcrypt-devel-2.5.7-1.2.el6.rf.i686.rpm
				rpm -i $cur_dir/conf/mhash-0.9.9.9-3.el6.i686.rpm
				rpm -i $cur_dir/conf/mhash-devel-0.9.9.9-3.el6.i686.rpm
			fi
		elif CentOSVerCheck 7;then
			check_installed "install_mhash " "${depends_prefix}/${mhash_filename}"
			check_installed "install_libmcrypt" "${depends_prefix}/${libmcrypt_filename}"
		fi
		
	else
		check_installed "install_m4" "${depends_prefix}/${m4_filename}"
		check_installed "install_autoconf" "${depends_prefix}/${autoconf_filename}"
		check_installed "install_libxml2" "${depends_prefix}/${libxml2_filename}"
		check_installed "install_openssl" "${depends_prefix}/${openssl_filename}"
		check_installed "install_zlib " "${depends_prefix}/${zlib_filename}"
		check_installed "install_curl" "${depends_prefix}/${libcurl_filename}"
		check_installed "install_pcre" "${depends_prefix}/${pcre_filename}"
		check_installed "install_libtool" "${depends_prefix}/${libtool_filename}"
		check_installed "install_libjpeg" "${depends_prefix}/${libjpeg_filename}"
		check_installed "install_libpng" "${depends_prefix}/${libpng_filename}"
		check_installed "install_freetype" "${depends_prefix}/${freetype_filename}"
		check_installed "install_mhash " "${depends_prefix}/${mhash_filename}"
		check_installed "install_libmcrypt" "${depends_prefix}/${libmcrypt_filename}"
	fi

}

#安装libevent
install_libevent(){
download_file "${libevent_other_link}" "${libevent_official_link}" "${libevent_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libevent_filename}.tar.gz
cd ${libevent_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${libevent_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${libevent_filename}"
}

#安装patch
install_patch(){
download_file "${patch_other_link}" "${patch_official_link}" "${patch_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${patch_filename}.tar.gz
cd ${patch_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${patch_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${patch_filename}"
}

#安装libiconv
install_libiconv(){
download_file "${libiconv_other_link}" "${libiconv_official_link}" "${libiconv_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libiconv_filename}.tar.gz
cd ${libiconv_filename}
make clean
./configure --prefix=/usr
#修复ubuntu 13.04 错误:‘gets’未声明(不在函数内)
if grep -q -i "Ubuntu 13.04" /etc/issue;then
		parallel_make
		sed -i 's/_GL_WARN_ON_USE (gets.*/\/\/&/' srclib/stdio.h
		parallel_make
else
	parallel_make
fi
	make install
}

#安装autoconf
install_autoconf(){
download_file "${autoconf_other_link}" "${autoconf_official_link}" "${autoconf_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${autoconf_filename}.tar.gz
cd ${autoconf_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${autoconf_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${autoconf_filename}"
}

#安装libxml2
install_libxml2(){
download_file "${libxml2_other_link}" "${libxml2_official_link}" "${libxml2_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libxml2_filename}.tar.gz
cd ${libxml2_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${libxml2_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${libxml2_filename}"
create_lib64_dir "${depends_prefix}/${libxml2_filename}"
}

#安装openssl
install_openssl(){
download_file "${openssl_other_link}" "${openssl_official_link}" "${openssl_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${openssl_filename}.tar.gz
cd ${openssl_filename}
make clean
error_detect "./config --prefix=${depends_prefix}/${openssl_filename} shared threads"
#并行编译可能会出错
error_detect "make"
error_detect "make install"
add_to_env "${depends_prefix}/${openssl_filename}"
create_lib64_dir "${depends_prefix}/${openssl_filename}"
}

#安装zlib
install_zlib(){
download_file "${zlib_other_link}" "${zlib_official_link}" "${zlib_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${zlib_filename}.tar.gz
cd ${zlib_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${zlib_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${zlib_filename}"
create_lib64_dir "${depends_prefix}/${zlib_filename}"
}

#安装libcurl
install_curl(){
download_file "${libcurl_other_link}" "${libcurl_official_link}" "${libcurl_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libcurl_filename}.tar.gz
cd ${libcurl_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${libcurl_filename} --with-ssl=${depends_prefix}/${openssl_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${libcurl_filename}"
create_lib64_dir "${depends_prefix}/${libcurl_filename}"
}

#安装pcre
install_pcre(){
download_file "${pcre_other_link}" "${pcre_official_link}" "${pcre_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${pcre_filename}.tar.gz
cd ${pcre_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${pcre_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${pcre_filename}"
create_lib64_dir "${depends_prefix}/${pcre_filename}"
}


#安装libtool
install_libtool(){
download_file "${libtool_other_link}" "${libtool_official_link}" "${libtool_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libtool_filename}.tar.gz
cd ${libtool_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${libtool_filename} --enable-ltdl-install"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${libtool_filename}"
create_lib64_dir "${depends_prefix}/${libtool_filename}"
}

#安装libjpeg
install_libjpeg(){
download_file "${libjpeg_other_link}" "${libjpeg_official_link}" "${libjpeg_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libjpeg_filename}.tar.gz
cd ${libjpeg_filename}
make clean
\cp ${depends_prefix}/${libtool_filename}/share/libtool/config/config.sub ./
\cp ${depends_prefix}/${libtool_filename}/share/libtool/config/config.guess ./
error_detect "./configure --prefix=${depends_prefix}/${libjpeg_filename} --enable-shared --enable-static"
mkdir -p ${depends_prefix}/${libjpeg_filename}/include/ ${depends_prefix}/${libjpeg_filename}/lib/ ${depends_prefix}/${libjpeg_filename}/bin/ ${depends_prefix}/${libjpeg_filename}/man/man1/
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${libjpeg_filename}"
create_lib64_dir "${depends_prefix}/${libjpeg_filename}"
}

#安装libpng
install_libpng(){
download_file "${libpng_other_link}" "${libpng_official_link}" "${libpng_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libpng_filename}.tar.gz
cd ${libpng_filename}
make clean
export LDFLAGS="-L${depends_prefix}/${zlib_filename}/lib"
export CPPFLAGS="-I${depends_prefix}/${zlib_filename}/include"
error_detect "./configure --prefix=${depends_prefix}/${libpng_filename}"
error_detect "parallel_make"
error_detect "make install"
unset LDFLAGS CPPFLAGS
add_to_env "${depends_prefix}/${libpng_filename}"
create_lib64_dir "${depends_prefix}/${libpng_filename}"
}


#安装mhash
install_mhash(){
download_file "${mhash_other_link}" "${mhash_official_link}" "${mhash_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${mhash_filename}.tar.gz
cd ${mhash_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${mhash_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${mhash_filename}"
create_lib64_dir "${depends_prefix}/${mhash_filename}"
}

#安装freetype
install_freetype(){
download_file "${freetype_other_link}" "${freetype_official_link}" "${freetype_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${freetype_filename}.tar.gz
cd ${freetype_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${freetype_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${freetype_filename}"
create_lib64_dir "${depends_prefix}/${freetype_filename}"
}

#安装libmcrypt
install_libmcrypt(){
download_file "${libmcrypt_other_link}" "${libmcrypt_official_link}" "${libmcrypt_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${libmcrypt_filename}.tar.gz
cd ${libmcrypt_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${libmcrypt_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${libmcrypt_filename}"
create_lib64_dir "${depends_prefix}/${libmcrypt_filename}"
}

#安装m4
install_m4(){
download_file "${m4_other_link}" "${m4_official_link}" "${m4_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${m4_filename}.tar.gz
cd ${m4_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${m4_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${m4_filename}"
}

#安装ImageMagick
install_ImageMagick(){
download_file "${ImageMagick_other_link}" "${ImageMagick_official_link}" "${ImageMagick_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${ImageMagick_filename}.tar.gz
cd ${ImageMagick_filename}
error_detect "./configure --prefix=${depends_prefix}/${ImageMagick_filename}"
error_detect "parallel_make"
error_detect "make install"
#修复php-ImageMagick找不到MagickWand.h的问题
cd ${depends_prefix}/${ImageMagick_filename}/include
ln -s ImageMagick-6 ImageMagick
add_to_env "${depends_prefix}/${ImageMagick_filename}"
}

#安装pkgconfig
install_pkgconfig(){
download_file "${pkgconfig_other_link}" "${pkgconfig_official_link}" "${pkgconfig_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${pkgconfig_filename}.tar.gz
cd ${pkgconfig_filename}
error_detect "./configure --prefix=${depends_prefix}/${pkgconfig_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${pkgconfig_filename}"
}

#安装cmake
install_cmake(){
download_file "${cmake_other_link}" "${cmake_official_link}" "${cmake_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${cmake_filename}.tar.gz
cd ${cmake_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${cmake_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${cmake_filename}"
}

#安装ncurses
install_ncurses(){
if [ "$mysql" == "${mysql5_1_filename}" ];then
	download_file "${ncurses_other_link2}" "${ncurses_official_link2}" "${ncurses_filename2}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ncurses_filename2}.tar.gz
	cd ${ncurses_filename2}
	make clean
	error_detect "./configure --prefix=${depends_prefix}/${ncurses_filename2} --with-shared"
	error_detect "parallel_make"
	error_detect "make install"
	add_to_env "${depends_prefix}/${ncurses_filename2}"
else
	download_file "${ncurses_other_link}" "${ncurses_official_link}" "${ncurses_filename}.tar.gz"
	cd $cur_dir/soft/
	tar xzvf ${ncurses_filename}.tar.gz
	cd ${ncurses_filename}
	make clean
	error_detect "./configure --prefix=${depends_prefix}/${ncurses_filename} --with-shared"
	error_detect "parallel_make"
	error_detect "make install"
	add_to_env "${depends_prefix}/${ncurses_filename}"	
fi	
}

#安装bison
install_bison(){
download_file "${bison_other_link}" "${bison_official_link}" "${bison_filename}.tar.gz"
cd $cur_dir/soft/
tar xzvf ${bison_filename}.tar.gz
cd ${bison_filename}
make clean
error_detect "./configure --prefix=${depends_prefix}/${bison_filename}"
error_detect "parallel_make"
error_detect "make install"
add_to_env "${depends_prefix}/${bison_filename}"
}