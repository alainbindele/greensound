# * Copyright (C) Alain Bindele Kiesse,- All Rights Reserved
# * Unauthorized copying of this file, via any medium is strictly prohibited
# * Proprietary and confidential
# * Written by Alain Bindele Kiesse <alain.bindele@gmail.com>, Feb 2019
# * License to use this software is permitted to personally licensed persons:
# * only for purposes related to GreenSound Project (PC-go Project)
# * Version: 0.1
#
#  Directive:	This script dumps analog parameter to database
#				It uses read.py (in the same dir) to read from USB serial
#  Platform:	Works for UNIX Based systems (MacOS Linux etc.)
#!/bin/bash

# setup ambient
#source ~/.bashrc
#source ~/.bash_profile
source ./device.config
source ./thinkerboard.conf

# Selectively clean the filesystem
function cleanup {
	if [ "$1" = "compressed" ]
	then 
		rm -f ./compressed/*
	fi

	if [ "$1" = "last_raw" ]
	then 
		rm -f ./last_raw/*
	fi

	if [ "$1" = "tmp" ]
	then 
		rm -f ./tmp/*
	fi
	
	if [ "$1" = "all" ]
	then
		cleanup compressed
		cleanup last_raw
		cleanup tmp
	fi
}

db_opts="-r -s"
db_executable="/usr/bin/mysql"
db_name="greensound"
db_extrafile="default_db.config"
query="SELECT samplesBeforeZip FROM \`config\` WHERE \`name\` LIKE 'default'"
folder_compressed_output="./compressed"
folder_raw_output="./last_raw"
folder_json_output="./json"
n_last_txt=20
n_rows_before_zip=`$db_executable --defaults-extra-file=$db_extrafile -D$db_name -e"$query" $db_opts | tail -n1`
verbose="1"
json_export="1"
updateThingsBoard="0"

if [ "$1" == "cleanup" ]
then
	if [ "$2" = "compressed" ]
	then 
		cleanup compressed
	fi

	if [ "$2" = "last_raw" ]
	then 
		cleanup last_raw
	fi

	if [ "$2" = "tmp" ]
	then 
		cleanup tmp
	fi

	if [ "$2" = "all" ]
	then 
		cleanup all
	fi
exit 0 
fi


# MainLoop and read continuously
while [ 1 ] 
do
	#setup initial variables
	date=`date +%s`

	#If folders do not exists create them in the format YYYYMMDD
	dateFolderName=`date +%Y%m%d`
	if [ ! -d $folder_raw_output/$dateFolderName ]
	then
		mkdir -p $folder_raw_output/$dateFolderName
		if [ $? -neq 0  ] 
 		then 
			if [ "$verbose" = "1" ]
			then 
				echo "Folder  $folder_raw_output/$dateFolderName cannot be created, check pathnames"
			fi
		fi
	fi

	if [ ! -d $folder_json_output/$dateFolderName ]
	then
		mkdir -p $folder_json_output/$dateFolderName
		if [ $? -neq 0  ] 
 		then 
			if [ "$verbose" = "1" ]
			then 
				echo "Folder  $folder_json_output/$dateFolderName cannot be created, check pathnames"
			fi
		fi
	fi

	if [ ! -d $folder_compressed_output/$dateFolderName ]
	then
		mkdir -p $folder_compressed_output/$dateFolderName
		if [ $? -neq 0  ] 
 		then 
			if [ "$verbose" = "1" ]
			then 
				echo "Folder  $folder_compressed_output/$dateFolderName cannot be created, check pathnames"
			fi
		fi
	fi
	# Set output directories (sure that they exists)
	output_file="$folder_raw_output/$dateFolderName/Greensound_acquire_$date.dat"
	output_json_file="$folder_json_output/$dateFolderName/Greensound_acquire_$date.dat.JSON"
	output_compressed="$folder_compressed_output/$dateFolderName/Greensound_acquire_$date.tar.gz"
	output_tmp_file="./tmp/Greensound_acquire_$date.dat"

	#write the file in the tmp dir
	python3 read.py $n_rows_before_zip >> $output_tmp_file
	#Save file in safe place
	cp $output_tmp_file $output_file
	#insert json export 

	if [ "$json_export" = "1" ]
	then 
		echo "[INFO] Export to JSON - $output_json_file" 
		sed -e 's/$/,/' -e '$ s/.$//' $output_tmp_file > $output_tmp_file.swp
		(echo -e "{ "ts":$date,"values":{" ; cat $output_tmp_file.swp ; echo -e "}}") > $output_json_file
		rm $output_tmp_file.swp
	fi

	#If thingboard must be updated, just do it
	if [ "$updateThingsBoard" = "1" ]
	then 
		if [ "$verbose" = "1" ]
		then 
			echo "Update to ThingsBoard" 
		fi
		count=0
		total=0
		for i in $( awk '{ print $1 }' $output_tmp_file ); do total=$(echo $total+$i | bc ); ((count++)); done
		mean=`echo "scale=2; $total / $count" | bc`
		curl POST -d "{"ts":$date,"value":$mean}" http://172.16.126.128:8080/api/v1/$token/telemetry --header "Content-Type:application/json" >/dev/null 2>&1
	fi

	#compress it and store the compressed copy too
	if [ "$verbose" = "1" ]
	then 
		echo "[INFO] Compress: $output_compressed" 
	fi
	# Compress the captured data to file
	tar zcvf $output_compressed $output_file >/dev/null 2>&1

	ndat=`ls $folder_raw_output | wc -l | sed -e 's/^[ \t]*//'`
	# Eliminate the oldest files that exceed n_last_txt in the raw folder
	if [ $ndat -ge $n_last_txt ]
	then
		((ndat-=$n_last_txt))
		for file in `ls last_raw/* | head -n$ndat` ; do rm $file && if [ "$verbose" = "1" ]; then  echo "[INFO] Cleanup! $file"; fi done
	fi
	#	query = ""
	#	$db_executable --defaults-extra-file=$db_extrafile -D$db_name -e"$query"
	# Cleanup temp files
	rm $output_tmp_file
	rm -f $output_tmp_file.swp
done



