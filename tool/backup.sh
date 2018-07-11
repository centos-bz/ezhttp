#!/bin/bash

CUR_DIR=`dirname $0`
LOG_DIR=${CUR_DIR}/log/
LOG_FILE=backup-$(date +%Y-%m-%d).log
LOG_PATH="$LOG_DIR/$LOG_FILE"
LOG_EXPIRE_DAYS=7
DATE_NAME=$(date +%Y%m%d-%H%M%S)



[[ -f "${CUR_DIR}/ini_parser.sh" ]] && . ${CUR_DIR}/ini_parser.sh || ( echo "file ${CUR_DIR}/ini_parser.sh not found.";exit 1 )
[[ -f "${CUR_DIR}/function.sh" ]] && . ${CUR_DIR}/function.sh || ( echo "file ${CUR_DIR}/function.sh not found.";exit 1 )
[[ -f "${CUR_DIR}/backup.ini" ]] || ( echo "file ${CUR_DIR}/backup.ini not found.";exit 1 )


#解析配置文件
parseIniFile < ${CUR_DIR}/backup.ini
getPropertyVar fileBackupDir file.fileBackupDir
getPropertyVar excludeRegex file.excludeRegex
getPropertyVar storageFileDir file.storageFileDir
getPropertyVar fileLocalExpireDays file.fileLocalExpireDays

getPropertyVar fileRemoteBackupTool file.fileRemoteBackupTool
getPropertyVar fileRsyncRemoteAddr file.fileRsyncRemoteAddr
getPropertyVar fileRsyncPort file.fileRsyncPort
getPropertyVar fileRsyncUsername file.fileRsyncUsername
getPropertyVar fileRsyncModuleName file.fileRsyncModuleName
getPropertyVar fileSshRemoteAddr file.fileSshRemoteAddr
getPropertyVar fileSshPort file.fileSshPort
getPropertyVar fileSshUsername file.fileSshUsername
getPropertyVar fileSshPassword file.fileSshPassword
getPropertyVar fileRemoteBackupDest file.fileRemoteBackupDest
getPropertyVar fileFtpServerAddr file.fileFtpServerAddr
getPropertyVar fileFtpPort file.fileFtpPort
getPropertyVar fileFtpUsername file.fileFtpUsername
getPropertyVar fileFtpPassword file.fileFtpPassword
getPropertyVar rsyncBinPath file.rsyncBinPath
getPropertyVar fileRemoteExpireDays file.fileRemoteExpireDays

getPropertyVar mysqlBackupTool mysql.mysqlBackupTool
getPropertyVar mysqlBinDir mysql.mysqlBinDir
getPropertyVar mysqlAddress mysql.mysqlAddress
getPropertyVar mysqlPort mysql.mysqlPort
getPropertyVar mysqlUser mysql.mysqlUser
getPropertyVar mysqlPass mysql.mysqlPass
getPropertyVar myCnfLocation mysql.myCnfLocation
getPropertyVar databaseSelectionPolicy mysql.databaseSelectionPolicy
getPropertyVar databasesBackup mysql.databasesBackup
getPropertyVar storageMysqlDir mysql.storageMysqlDir
getPropertyVar mysqlLocalExpireDays mysql.mysqlLocalExpireDays

getPropertyVar mysqlRemoteBackupTool mysql.mysqlRemoteBackupTool
getPropertyVar mysqlRsyncRemoteAddr mysql.mysqlRsyncRemoteAddr
getPropertyVar mysqlRsyncPort mysql.mysqlRsyncPort
getPropertyVar mysqlRsyncUsername mysql.mysqlRsyncUsername
getPropertyVar mysqlRsyncModuleName mysql.mysqlRsyncModuleName
getPropertyVar mysqlSshRemoteAddr mysql.mysqlSshRemoteAddr
getPropertyVar mysqlSshPort mysql.mysqlSshPort
getPropertyVar mysqlSshUsername mysql.mysqlSshUsername
getPropertyVar mysqlSshPassword mysql.mysqlSshPassword
getPropertyVar mysqlRemoteBackupDest mysql.mysqlRemoteBackupDest
getPropertyVar mysqlFtpServerAddr mysql.mysqlFtpServerAddr
getPropertyVar mysqlFtpPort mysql.mysqlFtpPort
getPropertyVar mysqlFtpUsername mysql.mysqlFtpUsername
getPropertyVar mysqlFtpPassword mysql.mysqlFtpPassword
getPropertyVar rsyncBinPath mysql.rsyncBinPath
getPropertyVar mysqlRemoteExpireDays mysql.mysqlRemoteExpireDays

# 删除过期日志
find $LOG_DIR -type f -mtime +${LOG_EXPIRE_DAYS} -exec rm -f {} \;

backup_files(){
	check_var_null fileBackupDir || exit 1
	check_var_null storageFileDir || exit 1
	check_var_null fileLocalExpireDays || exit 1

	#文件本地备份
	[[ -d "$storageFileDir" ]] || mkdir -p ${storageFileDir}
	filePrefix="file"
	fileName="${filePrefix}-${DATE_NAME}"
	[[ "$excludeRegex" == "" ]] && excludeFile="" || excludeFile="--exclude=$excludeRegex"

	log "INFO" "start to backup ${fileBackupDir} to ${storageFileDir}/${fileName}..."
	log "INFO" "execute command rsync -azvP ${excludeFile} ${fileBackupDir} ${storageFileDir}/${fileName}"
	rsync -az ${excludeFile} ${fileBackupDir} ${storageFileDir}/${fileName} >> ${LOG_PATH} 2>&1
	log "INFO" "backup done."

	log "INFO" "start to compress file..."
	tar czf ${storageFileDir}/${fileName}.tar.gz ${storageFileDir}/${fileName} >> ${LOG_PATH} 2>&1
	log "INFO" "compress done."

	log "INFO" "deleting file backup dir..."
	rm -rf ${storageFileDir}/${fileName} >> ${LOG_PATH} 2>&1

	log "INFO" "start to delete the ${fileLocalExpireDays} days ago sexpire file..."
	find ${storageFileDir}/${filePrefix}-* -type f -mtime +${fileLocalExpireDays} -exec rm -f {} \; >> ${LOG_PATH} 2>&1
	log "INFO" "delete done."

	#文件远程备份
	if [[ "$fileRemoteBackupTool" == "rsync" ]]; then
		check_var_null fileRsyncRemoteAddr || exit 1
		check_var_null fileRsyncPort || exit 1
		check_var_null fileRsyncUsername || exit 1
		check_var_null fileRsyncModuleName || exit 1
		check_var_null rsyncBinPath || exit 1

		log "INFO" "tranfering backup file to remote server $fileRsyncRemoteAddr with rsync tool"
		${rsyncBinPath} -azvP --password-file=/etc/rsync.pass ${storageFileDir}/${fileName}.tar.gz rsync://${fileRsyncUsername}@${fileRsyncRemoteAddr}:${fileRsyncPort}/${fileRsyncModuleName} >> ${LOG_PATH} 2>&1

	elif [[ "$fileRemoteBackupTool" == "rsync-ssh" ]]; then

		check_var_null fileSshRemoteAddr || exit 1
		check_var_null fileSshPort || exit 1
		check_var_null fileSshUsername || exit 1
		check_var_null fileSshPassword || exit 1
		check_var_null fileRemoteBackupDest || exit 1
		check_var_null rsyncBinPath || exit 1

		log "INFO" "tranfering backup file to ssh server $fileSshRemoteAddr with rsync ssh tool"
		expect -c "
			spawn ${rsyncBinPath} -azvP -e \"ssh -p ${fileSshPort}\" ${storageFileDir}/${fileName}.tar.gz ${fileSshUsername}@${fileSshRemoteAddr}:${fileRemoteBackupDest}
			expect {
			\"*assword\" {set timeout 300; send \"${fileSshPassword}\r\";}
			\"yes/no\" {send \"yes\r\"; exp_continue;}
		}
		expect eof" >> ${LOG_PATH} 2>&1
		

	elif [[ "$fileRemoteBackupTool" == "dropbox" ]]; then
		check_var_null fileRemoteBackupDest || exit 1
		check_var_null fileRemoteExpireDays || exit 1

		log "INFO" "tranfering backup file to dropbox server with dropbox_uploader tool"
		${CUR_DIR}/dropbox_uploader.sh upload ${storageFileDir}/${fileName}.tar.gz ${fileRemoteBackupDest}/$(date +%Y%m%d)/${fileName}.tar.gz >> ${LOG_PATH} 2>&1

		log "INFO" "deleting directory ${fileRemoteBackupDest}/$(date -d "$fileRemoteExpireDays days ago" +%Y%m%d)/"
		${CUR_DIR}/dropbox_uploader.sh delete ${fileRemoteBackupDest}/$(date -d "$fileRemoteExpireDays days ago" +%Y%m%d)/ >> ${LOG_PATH} 2>&1


	elif [[ "$fileRemoteBackupTool" == "ftp" ]]; then
		check_var_null fileFtpServerAddr || exit 1		
		check_var_null fileFtpPort || exit 1		
		check_var_null fileFtpUsername || exit 1		
		check_var_null fileFtpPassword || exit 1		
		check_var_null fileRemoteBackupDest || exit 1
		check_var_null fileRemoteExpireDays || exit 1
		local today=$(date +%Y%m%d)
		local expireDay=$(date -d "$fileRemoteExpireDays days ago" +%Y%m%d)

		log "INFO" "uploading backup file to ftp server $fileFtpServerAddr..."
		ftp -n -i $fileFtpServerAddr $fileFtpPort >> ${LOG_PATH} 2>&1 <<END_SCRIPT
		quote USER $fileFtpUsername
		quote PASS $fileFtpPassword
		cd $fileRemoteBackupDest
		mkdir $today
		cd $today
		lcd $storageFileDir
		mput $fileName.tar.gz
		cd ..
		mdelete $expireDay/*
		rm $expireDay

		quit
END_SCRIPT

	fi

}

#mysql备份
backup_mysql(){
	check_var_null mysqlBackupTool || exit 1
	check_var_null mysqlUser || exit 1
	check_var_null mysqlPass || exit 1
	check_var_null databaseSelectionPolicy || exit 1
	check_var_null storageMysqlDir || exit 1
	check_var_null mysqlLocalExpireDays || exit 1
	check_var_null mysqlBinDir || exit 1
	check_var_null mysqlAddress || exit 1
	check_var_null mysqlPort || exit 1

	#mysql本地备份
	[[ -d "$storageMysqlDir" ]] || mkdir -p ${storageMysqlDir}
	if ${mysqlBinDir}/mysql -h${mysqlAddress} -P${mysqlPort} -u${mysqlUser} -p${mysqlPass} -e "select 1" > /dev/null 2>&1;then
		log "INFO" "test mysql connection ok."
	else
		log "ERROR" "can not connect mysql server."
		exit 1
	fi

	databasesName=`${mysqlBinDir}/mysql -N -h${mysqlAddress} -P${mysqlPort} -u${mysqlUser} -p${mysqlPass} -e "show databases;" | grep -v -E "information_schema|test|performance_schema"`
	if [[ "$databaseSelectionPolicy" == "exclude" ]]; then
		dbExcludeReg=`echo "$databasesBackup" | tr " " "|"`
		databasesBackup=`echo $databasesName | grep -v -E "$dbExcludeReg"`

	elif [[ "$databaseSelectionPolicy" == "include" ]]; then
		check_var_null databasesBackup || exit 1
		databasesBackup="$databasesBackup"

	elif [[ "$databaseSelectionPolicy" == "all" ]]; then
		databasesBackup="$databasesName"

	fi		

	log "INFO" "start to backup mysql..."
	local mysqlDbsFileName=""
	if [[ "$mysqlBackupTool" == "mysqldump" ]]; then
		for db in $databasesBackup;do
			mysqlDbsFileName="$mysqlDbsFileName mysql-${DATE_NAME}-${db}.sql.gz"
			log "INFO" "start to backup database $db..."
			${mysqlBinDir}/mysqldump --master-data=2 -e --single-transaction --default-character-set=utf8 --skip-add-locks -R -f --max_allowed_packet=16777216 --net_buffer_length=16384 -h${mysqlAddress} -P${mysqlPort} -u${mysqlUser} -p${mysqlPass} $db > ${storageMysqlDir}/mysql-${DATE_NAME}-${db}.sql 
			gzip ${storageMysqlDir}/mysql-${DATE_NAME}-${db}.sql >> ${LOG_PATH} 2>&1
		done

		log "INFO" "mysql database backup done."

	elif [[ "$mysqlBackupTool" == "innobackupex" ]]; then
		mysqlDbsFileName="mysql-${DATE_NAME}.tar.gz"
		check_var_null myCnfLocation || exit 1
		log "INFO" "start backup databases ${databasesBackup}..."
		innobackupex --user=${mysqlUser} --host=${mysqlAddress} --password=${mysqlPass} --defaults-file=${myCnfLocation} --no-timestamp --include="nosub.*|mysql.*"  ${storageMysqlDir}/mysql-${DATE_NAME} >> ${LOG_PATH} 2>&1
		log "INFO" "start compress mysql backup file..."
		tar czvf ${storageMysqlDir}/mysql-${DATE_NAME}.tar.gz ${storageMysqlDir}/mysql-${DATE_NAME}  >> ${LOG_PATH} 2>&1
		log "INFO" "deleting database dir..."
		rm -rf ${storageMysqlDir}/mysql-${DATE_NAME} >> ${LOG_PATH} 2>&1

	fi

	log "INFO" "start to delete the ${mysqlLocalExpireDays} days ago sexpire file..."
	find ${storageMysqlDir}/*.gz -type f -mtime +${mysqlLocalExpireDays} -exec rm -f {} \;
	log "INFO" "delete done."


	#mysql远程备份

	if [[ "$mysqlRemoteBackupTool" == "rsync" ]]; then
		check_var_null mysqlRsyncRemoteAddr || exit 1
		check_var_null mysqlRsyncPort || exit 1
		check_var_null mysqlRsyncUsername || exit 1
		check_var_null mysqlRsyncModuleName || exit 1
		check_var_null rsyncBinPath || exit 1

		log "INFO" "tranfering backup file to remote server $mysqlRsyncRemoteAddr with rsync tool"
		${rsyncBinPath} -azvP --password-file=/etc/rsync.pass ${storageMysqlDir}/mysql-${DATE_NAME}* rsync://${mysqlRsyncUsername}@${mysqlRsyncRemoteAddr}:${mysqlRsyncPort}/${mysqlRsyncModuleName} >> ${LOG_PATH} 2>&1

	elif [[ "$mysqlRemoteBackupTool" == "rsync-ssh" ]]; then

		check_var_null mysqlSshRemoteAddr || exit 1
		check_var_null mysqlSshPort || exit 1
		check_var_null mysqlSshUsername || exit 1
		check_var_null mysqlSshPassword || exit 1
		check_var_null mysqlRemoteBackupDest || exit 1
		check_var_null rsyncBinPath || exit 1

		log "INFO" "tranfering backup file to ssh server $mysqlSshRemoteAddr with rsync ssh tool"
		for dbFile in $mysqlDbsFileName;do
			expect -c "
				spawn ${rsyncBinPath} -azvP -e \"ssh -p ${mysqlSshPort}\" ${storageMysqlDir}/${dbFile} ${mysqlSshUsername}@${mysqlSshRemoteAddr}:${mysqlRemoteBackupDest}
				expect {
				\"*assword\" {set timeout 300; send \"${mysqlSshPassword}\r\";}
				\"yes/no\" {send \"yes\r\"; exp_continue;}
			}
			expect eof" >> ${LOG_PATH} 2>&1
		done	
		

	elif [[ "$mysqlRemoteBackupTool" == "dropbox" ]]; then
		check_var_null mysqlRemoteBackupDest || exit 1
		check_var_null mysqlRemoteExpireDays || exit 1

		log "INFO" "tranfering backup file to dropbox server with dropbox_uploader tool"
		for dbFile in $mysqlDbsFileName;do
			${CUR_DIR}/dropbox_uploader.sh upload ${storageMysqlDir}/$dbFile ${mysqlRemoteBackupDest}/$(date +%Y%m%d)/$dbFile >> ${LOG_PATH} 2>&1
		done

		log "INFO" "deleting directory ${mysqlRemoteBackupDest}/$(date -d "$mysqlRemoteExpireDays days ago" +%Y%m%d)/"
		${CUR_DIR}/dropbox_uploader.sh delete ${mysqlRemoteBackupDest}/$(date -d "$mysqlRemoteExpireDays days ago" +%Y%m%d)/ >> ${LOG_PATH} 2>&1


	elif [[ "$mysqlRemoteBackupTool" == "ftp" ]]; then
		check_var_null mysqlFtpServerAddr || exit 1		
		check_var_null mysqlFtpPort || exit 1		
		check_var_null mysqlFtpUsername || exit 1		
		check_var_null mysqlFtpPassword || exit 1		
		check_var_null mysqlRemoteBackupDest || exit 1
		check_var_null mysqlRemoteExpireDays || exit 1
		local today=$(date +%Y%m%d)
		local expireDay=$(date -d "$mysqlRemoteExpireDays days ago" +%Y%m%d)

		log "INFO" "uploading backup file to ftp server $mysqlFtpServerAddr..."
		ftp -n -i $mysqlFtpServerAddr $mysqlFtpPort >> ${LOG_PATH} 2>&1 <<END_SCRIPT
		quote USER $mysqlFtpUsername
		quote PASS $mysqlFtpPassword
		cd $mysqlRemoteBackupDest
		mkdir $today
		cd $today
		lcd $storageMysqlDir
		mput $mysqlDbsFileName
		cd ..
		mdelete $expireDay/*
		rm $expireDay

		quit
END_SCRIPT

	fi

}

case "$1" in
	file) backup_files;;
	mysql) backup_mysql;;
	*) echo "Usage: $0 (file|mysql)"
esac
