#! /bin/bash

<< comment
Script for backup and log rotation

comment

function display_usage(){
	echo "Usage: ./backup.sh <path to your source> <path to backup folder>"
}

if [ $# -eq 0 ]; then 
	display_usage
fi

source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_dir=$2

function create_backup(){
	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null

	if [ $? -eq 0 ]; then
		echo "backup generated successfully for ${timestamp}"
	fi
}

function log_rotation(){
	backups=($(ls -t "${backup_dir}/backup_"*.zip))

	if [ "${#backups[@]}" -gt 5 ]; then
		echo "performing rotation for 5 days"
		backups_to_remove="${backups[@]:5}"
	

		for backup in "${backups_to_remove[@]}";
		do
			rm -f ${backup}
		done
	fi
}



create_backup
log_rotation


